# App Flow

## Passenger Flow

```
[Home / Search Screen]
   - "From Stop" selector
   - "To Stop" selector
   - "Find Bus" button
        |
        v
[Results List Screen]
   - List of matching buses
   - Bus number, route name, next departure time
   - Status badge: "Running" / "Delayed" / "Not Started"
   - Tap a bus →
        |
        v
[Live Tracking Screen]
   - Map with live bus position (Leaflet + OSM)
   - Stop-by-stop list below/beside map:
       - Stop name, distance (km), arrival/departure time
       - Highlight current position on route line
   - Status line: "Bus left [Stop] at [time]" or "Not started from [origin]"
   - Auto-refresh every few seconds
```

## Driver Flow

```
[Driver Login/Select Screen]
   - Select assigned bus/route (or simple PIN/code entry)
        |
        v
[Driver Trip Screen]
   - "Start Trip" button → begins sharing GPS location
   - Shows current status: "Sharing location..."
   - "End Trip" button → stops sharing, marks trip complete
```

## Admin Flow (later phase, optional for MVP)

```
[Admin Dashboard]
   - Add/edit routes, stops, buses, drivers
   - View all active buses on a map
```

## Navigation Notes

- Passenger flow needs NO login (open access)
- Driver flow needs a lightweight identity check (unique code/login per bus) — see rules.md
- Back button always returns to previous screen (Results ← Search, Live Tracking ← Results)
