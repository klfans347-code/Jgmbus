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
- **Aug 2026** — Critical Bug Fixes (Driver GPS Sharing & Admin Route/Stop Insertion):
  - **Bug 1 (Driver Location Sharing)**: Fixed Geolocation permissions/HTTPS checks, initial fallback coordinates, multi-channel broadcast (Supabase upsert + LocalStorage + BroadcastChannel), and passenger Realtime subscriber sync (`index.html`).
  - **Bug 2 (Admin Stop/Route Creation)**: Resolved Supabase RLS policy restrictions (created `schema-fixed.sql`), sanitized Postgres UUID inputs (`operator_id`, `route_id`), linked `stop.route_id` with exact returned Supabase UUIDs, added error handling in Admin terminal log.
