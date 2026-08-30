// ============================================================
// DRIVER SERVICE WORKER — Background GPS Tracking
// Works when app is minimized, screen is off, page is hidden
// ============================================================

const DRIVER_SW_VERSION = 'driver-v3';
const SUPABASE_URL = 'https://fyenwpoiyibkhmsooiec.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ5ZW53cG9peWlia2htc29vaWVjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY2NjA5NzAsImV4cCI6MjEwMjIzNjk3MH0.Eg5ZOmHcNGmyFhRt0cBAgNb-VtQvdAqXkI6l0tsESVk';

// In-memory trip state (populated by messages from driver.html page)
let tripState = null; // { bus_id, bus_number, lat, lng, lastPassedStopSeq, routeStops }

// ── INSTALL / ACTIVATE ──────────────────────────────────────
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (e) => {
  e.waitUntil(self.clients.claim());
  console.log('[Driver SW] Activated:', DRIVER_SW_VERSION);
});

// ── MESSAGES FROM DRIVER PAGE ───────────────────────────────
self.addEventListener('message', (event) => {
  const msg = event.data;
  if (!msg || !msg.type) return;

  switch (msg.type) {

    // Driver started trip — save state + start background interval
    case 'TRIP_START':
      tripState = {
        bus_id: msg.bus_id,
        bus_number: msg.bus_number,
        lat: msg.lat,
        lng: msg.lng,
        lastPassedStopSeq: msg.lastPassedStopSeq || 0,
        routeStops: msg.routeStops || []
      };
      console.log('[Driver SW] Trip started for bus:', msg.bus_number);

      // Show persistent notification so Android keeps SW alive
      showTripNotification(msg.bus_number, 'Trip Started', 'GPS tracking is active in background.');
      break;

    // Driver sent new GPS coordinate
    case 'GPS_UPDATE':
      if (tripState) {
        tripState.lat = msg.lat;
        tripState.lng = msg.lng;
        tripState.lastPassedStopSeq = msg.lastPassedStopSeq;
        // Upload to Supabase from SW background context
        uploadToSupabase(tripState);
      }
      break;

    // Driver stopped trip
    case 'TRIP_STOP':
      if (tripState) {
        uploadToSupabase({ ...tripState, tripStatus: 'completed', lastPassedStopSeq: 0 });
      }
      tripState = null;
      clearTripNotification();
      console.log('[Driver SW] Trip stopped.');
      break;

    // Keep-alive ping from foreground page
    case 'KEEPALIVE':
      event.source && event.source.postMessage({ type: 'KEEPALIVE_ACK' });
      break;
  }
});

// ── PERIODIC BACKGROUND SYNC (Android Chrome support) ───────
self.addEventListener('periodicsync', (event) => {
  if (event.tag === 'driver-gps-sync' && tripState) {
    event.waitUntil(uploadToSupabase(tripState));
  }
});

// ── BACKGROUND SYNC (offline queue retry) ───────────────────
self.addEventListener('sync', (event) => {
  if (event.tag === 'driver-location-sync' && tripState) {
    event.waitUntil(uploadToSupabase(tripState));
  }
});

// ── UPLOAD LOCATION TO SUPABASE ─────────────────────────────
async function uploadToSupabase(state) {
  if (!state || !state.bus_id) return;
  const status = state.tripStatus || 'in_progress';
  try {
    const response = await fetch(`${SUPABASE_URL}/rest/v1/bus_locations`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'apikey': SUPABASE_ANON_KEY,
        'Authorization': `Bearer ${SUPABASE_ANON_KEY}`,
        'Prefer': 'resolution=merge-duplicates'
      },
      body: JSON.stringify({
        bus_id: state.bus_id,
        lat: state.lat,
        lng: state.lng,
        last_passed_stop_sequence: state.lastPassedStopSeq || 0,
        updated_at: new Date().toISOString(),
        trip_status: status
      })
    });
    if (response.ok) {
      console.log(`[Driver SW] Uploaded to Supabase: Bus ${state.bus_number} lat=${state.lat} lng=${state.lng} seq=${state.lastPassedStopSeq}`);
    } else {
      console.warn('[Driver SW] Supabase upload failed:', response.status, await response.text());
    }
  } catch (err) {
    console.warn('[Driver SW] Upload error (offline?):', err.message);
    // Register background sync for retry when back online
    try {
      await self.registration.sync.register('driver-location-sync');
    } catch(e) {}
  }
}

// ── PERSISTENT NOTIFICATION (keeps SW alive on Android) ─────
async function showTripNotification(busNum, title, body) {
  try {
    await self.registration.showNotification(`🚌 ${busNum} — CityBus Driver`, {
      body: body || 'GPS tracking active. Location being shared with passengers.',
      icon: '/manifest-icon-192.png',
      badge: '/manifest-icon-192.png',
      tag: 'driver-trip-active',
      renotify: false,
      requireInteraction: true, // Don't auto-dismiss
      silent: true,
      actions: [
        { action: 'open', title: '📋 Open App' },
        { action: 'stop', title: '⏹ Stop Trip' }
      ],
      data: { busNum }
    });
  } catch(e) {
    console.warn('[Driver SW] Notification error:', e);
  }
}

async function clearTripNotification() {
  try {
    const notifications = await self.registration.getNotifications({ tag: 'driver-trip-active' });
    notifications.forEach(n => n.close());
  } catch(e) {}
}

// ── NOTIFICATION CLICK HANDLER ───────────────────────────────
self.addEventListener('notificationclick', (event) => {
  event.notification.close();

  if (event.action === 'stop') {
    // Send stop message to all open driver pages
    event.waitUntil(
      self.clients.matchAll({ type: 'window' }).then(clients => {
        clients.forEach(client => {
          if (client.url.includes('driver.html')) {
            client.postMessage({ type: 'SW_STOP_TRIP' });
          }
        });
      })
    );
    return;
  }

  // Open/focus driver app
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(clients => {
      const driverClient = clients.find(c => c.url.includes('driver.html'));
      if (driverClient) return driverClient.focus();
      return self.clients.openWindow('/driver.html');
    })
  );
});

// ── FETCH (network-first for driver page) ───────────────────
self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;
  // Let driver page load fresh
  event.respondWith(
    fetch(event.request).catch(() => caches.match(event.request))
  );
});
