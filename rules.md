# Project Rules (for Claude Code)

## General
- Mobile-first only — assume the primary user is on a phone browser
- Prefer minimal dependencies — avoid heavy frameworks unless truly needed
- Keep frontend as close to single-file HTML/CSS/JS as practical for Phase 1 (dummy data stage)
- Once Supabase is connected, a small JS module structure is fine — no need to force everything into one file at that point

## Language & Content
- All user-facing labels: Bengali first, English secondary
- Keep copy short — icons/short labels over long sentences

## Map & Location
- Use Leaflet.js + OpenStreetMap tiles only (no Google Maps API — cost reasons)
- Bus location updates: reasonable interval (e.g. every 5-10 seconds) — avoid draining driver's phone battery/data

## Backend
- Supabase only for Phase 1 backend (no custom server)
- Driver identity: simple unique `driver_code` per bus — no complex auth system needed for MVP
- Enforce data isolation between operators using Supabase Row Level Security

## Scope Discipline
- Do NOT build booking/payment/seat selection — out of scope for Phase 1 (see PRD, Phase 2 features)
- Do NOT add push notifications in Phase 1 — browser-based live view only

## Data
- Until real client data arrives, use dummy/sample routes, stops, and buses (mark clearly as dummy in code comments)

## Hosting/Deploy
- Target host: Netlify, connected to a GitHub repo for auto-deploy
- Keep build output deployable without a build step where possible (or document build command clearly if one is introduced)

## Tracking Progress
- Update `tracker.md` as tasks are completed
- Do not mark a phase "done" until tested on an actual phone browser, not just desktop
