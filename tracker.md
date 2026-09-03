# Progress Tracker

_Update this file as tasks are completed. Claude Code can edit this directly during builds._

## Status: Phase 4 Complete → Starting Phase 5 (Hosting)

| Phase | Status | Notes |
|---|---|---|
| PRD & Planning | ✅ Done | See trd.md, appflow.md, design.md, schema.md |
| Phase 1: Static Frontend | ✅ Done | 3 screens: Search, Results, Live Tracking (dummy data) |
| Phase 2: Map Integration | ✅ Done | Leaflet.js + OSM tiles, route polyline, stop pins, live movement simulation |
| Phase 3: Supabase Backend | ✅ Done | Postgres schema, RLS policies, sample data, Supabase SDK + Realtime integration |
| Phase 4: Driver App + Live Location | ✅ Done | driver.html with driver_code auth, Geolocation API, Supabase bus_locations write |
| Phase 5: Hosting | 🔲 Not started | |
| Phase 6: PWA Conversion | 🔲 Not started | |
| Phase 7: APK + Play Store | 🔲 Not started | |
| Phase 8: Real Data / Handover | 🔲 Not started | |

## Open Items / Decisions Pending

- [ ] Finalize app name/brand
- [ ] Get real route/stop data from client
- [ ] Finalize color scheme/branding
- [ ] Confirm number of active bus operators onboarding at launch

## Log

- **Aug 2026** — PRD finalized (10-20 buses, multi-operator, OSM, driver-phone GPS, Bengali-first, UI inspired by "Where is My Train")
- **Aug 2026** — Phase 2 Map Integration complete: OpenStreetMap tiles via Leaflet.js, route polyline rendering, stop pins with popups, custom bus emoji marker, and interactive live movement simulation along route stops
- **Aug 2026** — Phase 3 Supabase Backend complete: Postgres schema with RLS policies, sample route/stop/bus data, Supabase SDK + Realtime integration in passenger & driver apps
- **Aug 2026** — Phase 4 Driver App complete: driver.html with driver_code auth, Geolocation API (5-10s interval), Supabase bus_locations live write, Supabase Realtime subscription for passenger live map
- **Aug 2026** — Comprehensive Admin Panel complete: admin.html with A-Z management (Operators, Routes, Stops, Buses, Driver Codes, Live Fleet Map, Realtime GPS Terminal Logs, and Supabase Config)
- **Aug 2026** — App Feature Upgrades & Bug Fixes: 
  - Driver App (`driver.html`): Added Route info display & Stop Marking feature ("Mark Reached" per stop).
  - Admin Panel (`admin.html`): Fixed Route & Stop creation forms/modals, added nested "+ Add Stop" to route, confirmed RLS compatibility.
  - Passenger App (`index.html`): Added Direct Bus Number Search tab ("Track Bus" by bus_number like JGM-01).
- **Aug 2026** — Stop-Based Live Tracking ("Where is My Train" Style) & GPS Auto-Detection Complete:
  - **Database Schema Update**: Added `last_passed_stop_sequence` column (INT, default 0) to `bus_locations` table in `schema.sql` and `schema-fixed.sql`.
  - **GPS Auto-Detection (`driver.html`)**: Implemented Haversine distance calculation to auto-detect when a bus comes within 200m threshold of a stop, automatically updating `last_passed_stop_sequence` without manual driver button taps. Added simulation controls for easy testing.
  - **Passenger App Redesign (`index.html`)**: Completely removed map component and implemented "Where is My Train" style vertical timeline tracking with passed stops (green checkmark, dimmed text), current bus position highlight (`🚌 BUS IS HERE`), upcoming stops, scheduled ETAs, and status banner ("Bus JGM-01 crossed Binpur Junction — 1 min ago").
  - **Supabase Realtime Sync**: Passenger app subscribes to `last_passed_stop_sequence` changes in Supabase Realtime, BroadcastChannel, and LocalStorage for zero-refresh instant UI updates.
- **Sep 2026** — Ponytail Refactor (`driver.html`): Removed ~124 lines of monkey-patch wrappers, duplicate Haversine math functions, dead stubs (`markStopReached`), redundant `pageshow` listener. Inlined all background/SW/WakeLock logic directly into `startTrip()`, `stopTrip()`, `uploadLocation()`. JS remains 100% valid, no behavior regression.
- **Sep 2026** — Real-Time Distance & ETA Calculator complete (`index.html`):
  - **Haversine Formula** (`getDistanceKm`): Calculates straight-line GPS distance in km between bus current position and each route stop.
  - **ETA Engine** (`getETALabel`): `ETA = (distance / 40 km/h) * 60 = minutes`. Shows "Arriving in X min" (< 60 min) or "Arriving at HH:MM AM/PM" (> 1 hour) or "Arriving Now" (< 50m).
  - **4-State Stop Timeline**: Passed (dim + strikethrough), Current (🚌 blue highlight), Next Stop (green dashed + animated blue ETA chip + "Bus is X km away"), Future Upcoming (distance + ETA from bus GPS).
  - **Realtime lat/lng**: `applyLiveUpdate()` helper receives `lat`, `lng`, `last_passed_stop_sequence` from all 3 channels (BroadcastChannel, LocalStorage, Supabase Realtime) and recalculates ETA on every GPS update without page refresh.
  - **Status Banner**: Shows "Bus → Next: [Stop] · X.X km · ⏱ Arriving in Y min" when GPS available.
- **Sep 2026** — Driver Button Fixes (`driver.html`):
  - Fixed `routeStops` offline login bug (was assigning route object instead of `.stops` array).
  - Converted `handleLogout`, `closeLogoutModal`, `confirmLogout` from `window.xxx = function()` to hoisted function declarations.
  - Added `attachButtonListeners()` called after every `showScreen('screen-trip')` for reliable mobile click handling.
  - Fixed CSS `bg-tracking-banner` double `display:none` inline style conflict.
  - Removed inline `onclick` from Start Trip / End Trip / Logout buttons; all handled via JS listeners only.
