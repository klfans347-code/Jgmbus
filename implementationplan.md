# Implementation Plan

## Phase 1: Static Frontend (Dummy Data)
- [x] Build Search screen UI
- [x] Build Results List screen UI (with dummy bus data)
- [x] Build Live Tracking screen UI (map + stop timeline, dummy static position)
- [x] Bengali-first labels throughout
- [x] Mobile-responsive check on real phone

## Phase 2: Map Integration
- [x] Add Leaflet.js + OpenStreetMap tiles
- [x] Render dummy bus marker on map
- [x] Render route line + stop markers
- [x] Simulate movement with dummy data (for testing before real GPS)

## Phase 3: Supabase Backend
- [x] Create Supabase project
- [ ] Set up tables per schema.md (RUN schema.sql in Supabase SQL Editor)
- [ ] Insert sample route/stop/bus data
- [ ] Connect passenger frontend to read from Supabase (replace dummy data)
- [ ] Verify RLS policies work (public read, driver write)

## Phase 4: Driver App + Live Location
- [x] Build simple Driver screen (select bus via driver_code)
- [x] Implement browser Geolocation API to capture GPS
- [x] Write location updates to `bus_locations` table (every few seconds)
- [x] Passenger screen subscribes via Supabase Realtime, map updates live

## Phase 5: Hosting
- [ ] Push code to GitHub repo
- [ ] Connect repo to Netlify for auto-deploy
- [ ] Test live URL on phone

## Phase 6: PWA Conversion
- [ ] Add manifest.json
- [ ] Add service worker (basic offline shell)
- [ ] Test "Add to Home Screen" on Android

## Phase 7: APK + Play Store
- [ ] Generate APK/AAB via PWABuilder.com
- [ ] Create Google Play Developer account
- [ ] Prepare app icon, screenshots, description, privacy policy
- [ ] Submit for review

## Phase 8: Client Handover / Real Data
- [ ] Replace dummy routes/stops with real client data
- [ ] Onboard actual drivers with their driver_codes
- [ ] Soft launch / test with a few buses before full rollout
