# Database Schema (Supabase / Postgres)

## Tables

### `operators`
| Column | Type | Notes |
|---|---|---|
| id | uuid (PK) | |
| name | text | Operator/company name |
| created_at | timestamp | |

### `routes`
| Column | Type | Notes |
|---|---|---|
| id | uuid (PK) | |
| operator_id | uuid (FK → operators) | |
| route_name | text | e.g. "Jhargram - Kharagpur" |
| route_code | text | Short code/number |
| created_at | timestamp | |

### `stops`
| Column | Type | Notes |
|---|---|---|
| id | uuid (PK) | |
| route_id | uuid (FK → routes) | |
| stop_name | text | |
| sequence_no | int | Order of stop on route |
| distance_km | numeric | Distance from route start |
| lat | numeric | |
| lng | numeric | |

### `buses`
| Column | Type | Notes |
|---|---|---|
| id | uuid (PK) | |
| route_id | uuid (FK → routes) | |
| operator_id | uuid (FK → operators) | |
| bus_number | text | Registration/display number |
| driver_code | text (unique) | Simple login code for driver |
| status | text | 'active' / 'inactive' |

### `bus_locations` (Realtime table — frequently updated)
| Column | Type | Notes |
|---|---|---|
| bus_id | uuid (PK, FK → buses) | One row per bus, updated repeatedly |
| lat | numeric | Current latitude |
| lng | numeric | Current longitude |
| updated_at | timestamp | Last GPS update time |
| trip_status | text | 'not_started' / 'in_progress' / 'completed' |

### `trips` (optional, for history/logging)
| Column | Type | Notes |
|---|---|---|
| id | uuid (PK) | |
| bus_id | uuid (FK → buses) | |
| started_at | timestamp | |
| ended_at | timestamp (nullable) | |

## Notes

- `bus_locations` is the table the passenger app subscribes to via Supabase Realtime
- `driver_code` on `buses` is the simple auth mechanism for Phase 1 (no full user accounts needed) — see rules.md
- Multi-operator isolation handled via `operator_id` on routes/buses — drivers can only update their own bus's location (enforce via Supabase Row Level Security policy matching driver_code)
