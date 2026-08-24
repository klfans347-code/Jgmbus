# Technical Requirements Document (TRD)
## Bus Tracker App (name TBD)

## 1. Tech Stack

| Layer | Technology | Notes |
|---|---|---|
| Frontend | HTML / CSS / JS (single-file where possible) | Mobile-first, no heavy build tools |
| Map | Leaflet.js + OpenStreetMap tiles | Free, no API key needed |
| Backend/Database | Supabase (Postgres + Realtime) | Free tier for MVP |
| Hosting | Netlify | Drag-drop or GitHub auto-deploy |
| App packaging | PWA → PWABuilder.com → APK | For Play Store publishing |
| Driver location source | Driver's phone GPS (browser Geolocation API) | No extra hardware |

## 2. Architecture Overview

```
[Driver's Phone Browser] --(GPS coords every few sec)--> [Supabase Realtime DB]
                                                                    |
                                                                    v
[Passenger's Phone Browser] <--(live subscribe)-- [Supabase Realtime DB]
                       |
                       v
              [Leaflet Map showing bus position]
```

- Driver app writes location to a `bus_locations` table/row (update, not insert-heavy)
- Passenger app subscribes to Supabase Realtime channel for live updates
- No native push notifications in Phase 1 (browser-based only)

## 3. Non-Functional Requirements

- Must work on low-end Android phones, 3G/4G
- Page load under 3 seconds on average connection
- Minimal data usage (small map tiles, no heavy assets)
- Works as installable PWA (offline shell at minimum)

## 4. Constraints

- No payment/booking system in Phase 1
- No native GPS hardware — relies on driver keeping browser tab open with location sharing on
- Multiple operators — each bus/driver needs isolated identity (unique ID/login) so location data doesn't cross-contaminate

## 5. Third-Party Services

| Service | Purpose | Cost |
|---|---|---|
| Supabase | DB + Realtime + Auth | Free tier (upgrade later if needed) |
| OpenStreetMap | Map tiles | Free |
| Netlify | Hosting | Free tier |
| PWABuilder | APK generation | Free |
| Google Play Console | Play Store publishing | $25 one-time |
