# Product Requirements Document (PRD)
## City Bus Live Tracking App

**Version:** 1.0 (Draft)
**Prepared by:** Animesh Mahata
**Date:** August 2026

---

## 1. Overview

A mobile-friendly web app that lets local city bus passengers see, in real time, where a bus currently is on its route — so they know how long to wait, whether the bus has already left, or whether to hurry to the stop.

**Not included in Phase 1:** ticket booking, seat selection, online payment (this is a tracking app, not a booking app — that can be Phase 2).

---

## 2. Problem Statement

Local city bus passengers currently have no way to know:
- Where the bus currently is
- How long until it reaches their stop
- Whether the bus has already passed

This causes wasted waiting time and missed buses.

---

## 3. Target Users

| Persona | Description |
|---|---|
| **Passenger** | Wants to check bus location before leaving home/office, avoid waiting blindly at the stop |
| **Bus Operator/Driver** | Needs a simple way to share their live location while driving (likely just needs a phone with GPS on) |
| **Admin (client)** | Manages routes, buses, and stops from a simple dashboard |

---

## 4. Goals

- Reduce passenger waiting uncertainty
- Simple enough that any bus driver can use it (no technical training)
- Fast-loading, low-data-usage (works on basic Android phones, 3G/4G)

---

## 5. Core Features — Phase 1 (MVP)

1. **Live Map View** — Shows bus icon(s) moving in real time on a map
2. **Route Selection** — Passenger picks their route/bus number
3. **Stop List with ETA** — List of stops on the route with estimated arrival time
4. **Search by Route/Stop** — Find which buses pass through a given stop
5. **Driver Location Sharing** — Simple screen for driver's phone to broadcast GPS location (stays on while driving)

## 6. Phase 2 (Future — Not in current scope)

- Seat booking & payment
- Ticket QR code / digital ticket
- Push notifications ("bus is 5 min away")
- Multiple city/operator support

---

## 7. User Flow (Passenger)

1. Open app → select route/bus number (or nearest stop)
2. See map with live bus location + ETA to their stop
3. Refreshes automatically every few seconds

## 8. User Flow (Driver)

1. Open driver link/app on their phone
2. Tap "Start Trip" → app shares GPS location continuously
3. Tap "End Trip" when route finishes

---

## 9. Technical Requirements (Important — please review)

⚠️ **Note:** Unlike a static portfolio site, this app needs a **live backend** to work — it can't be a single self-contained HTML file, because bus location data has to update in real time and be shared between the driver's phone and passengers' phones.

Suggested stack:
- **Frontend:** Simple web app (mobile-first), works in browser — no app install needed
- **Backend/Database:** Firebase Realtime Database or Supabase (both have free tiers, good for MVP)
- **Maps:** Google Maps API or OpenStreetMap (OSM is free — good for cost control)
- **Driver location source:** Driver's own phone GPS (no extra hardware needed for MVP)
- **Multi-operator note:** Since buses belong to multiple operators, each driver/bus needs its own simple login or unique link so location data doesn't mix up between buses

---

## 10. Design/UI Notes

- Mobile-first (most users will open this on phone browsers)
- Minimal text, large tap targets, works for less tech-savvy users
- Bengali + English labels (local language support)
- **UI reference: "Where is My Train" app** — client wants a similar flow:
  - Search screen: From Stop / To Stop selector → "Find Bus" button
  - Results list: matching buses with next departure time, running status (e.g. "Running" / "Delayed")
  - Live tracking screen: stop-by-stop list with arrival/departure time, distance, current live position marker on the route line, status line like "Bus left [Stop] at [time]" or "Not started yet"

---

## 11. Success Metrics

- Number of daily active passengers checking bus location
- Reduction in average passenger wait complaints
- Driver adoption (% of buses actively sharing location)

---

## 12. Confirmed Requirements

- **Bus count:** Approximately 10-20 buses in Phase 1
- **Ownership:** Multiple operators (not a single company)
- **Maps:** OpenStreetMap (OSM) — free, no per-request cost
- **GPS source:** Driver's own phone (no separate GPS hardware needed)

---

## 13. Timeline (Placeholder — fill in after client discussion)

| Milestone | Target |
|---|---|
| Design finalized | TBD |
| MVP backend + driver app | TBD |
| Passenger-facing app live | TBD |
