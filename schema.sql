-- ========================================================
-- CITY BUS LIVE TRACKER — SUPABASE DATABASE SCHEMA (PostgreSQL)
-- Project Ref: fyenwpoiyibkhmsooiec
-- ========================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. OPERATORS TABLE
CREATE TABLE IF NOT EXISTS public.operators (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. ROUTES TABLE
CREATE TABLE IF NOT EXISTS public.routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    operator_id UUID REFERENCES public.operators(id) ON DELETE CASCADE,
    route_name TEXT NOT NULL,
    route_code TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. STOPS TABLE
CREATE TABLE IF NOT EXISTS public.stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    stop_name TEXT NOT NULL,
    sequence_no INT NOT NULL,
    distance_km NUMERIC(5,2) DEFAULT 0,
    lat NUMERIC(9,6) NOT NULL,
    lng NUMERIC(9,6) NOT NULL
);

-- 4. BUSES TABLE
CREATE TABLE IF NOT EXISTS public.buses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    operator_id UUID REFERENCES public.operators(id) ON DELETE CASCADE,
    bus_number TEXT NOT NULL,
    driver_code TEXT UNIQUE NOT NULL,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

-- 5. BUS_LOCATIONS TABLE (Realtime Enabled)
CREATE TABLE IF NOT EXISTS public.bus_locations (
    bus_id UUID PRIMARY KEY REFERENCES public.buses(id) ON DELETE CASCADE,
    lat NUMERIC(9,6) NOT NULL,
    lng NUMERIC(9,6) NOT NULL,
    last_passed_stop_sequence INT DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    trip_status TEXT DEFAULT 'not_started' CHECK (trip_status IN ('not_started', 'in_progress', 'completed'))
);

ALTER TABLE public.bus_locations ADD COLUMN IF NOT EXISTS last_passed_stop_sequence INT DEFAULT 0;

-- 6. TRIPS TABLE (Optional for trip history)
CREATE TABLE IF NOT EXISTS public.trips (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bus_id UUID REFERENCES public.buses(id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    ended_at TIMESTAMP WITH TIME ZONE
);

-- ========================================================
-- ENABLE REALTIME ON bus_locations
-- ========================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.bus_locations;

-- ========================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ========================================================
ALTER TABLE public.operators ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.buses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bus_locations ENABLE ROW LEVEL SECURITY;

-- Allow Public Read Access (Passenger App)
CREATE POLICY "Allow public read access for operators" ON public.operators FOR SELECT USING (true);
CREATE POLICY "Allow public read access for routes" ON public.routes FOR SELECT USING (true);
CREATE POLICY "Allow public read access for stops" ON public.stops FOR SELECT USING (true);
CREATE POLICY "Allow public read access for buses" ON public.buses FOR SELECT USING (true);
CREATE POLICY "Allow public read access for bus_locations" ON public.bus_locations FOR SELECT USING (true);

-- Allow Public Write & Insert Access (Admin & Driver Console)
CREATE POLICY "Allow public write access for operators" ON public.operators FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public write access for routes" ON public.routes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public write access for stops" ON public.stops FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow public write access for buses" ON public.buses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow location updates for active buses" ON public.bus_locations FOR ALL USING (true) WITH CHECK (true);

-- ========================================================
-- SAMPLE DATA INSERTION (Jhargram - Kharagpur Route)
-- ========================================================

-- Insert Operator
INSERT INTO public.operators (id, name) VALUES
('11111111-1111-1111-1111-111111111111', 'JGM Paribahan Services')
ON CONFLICT (id) DO NOTHING;

-- Insert Route
INSERT INTO public.routes (id, operator_id, route_name, route_code) VALUES
('22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Jhargram - Kharagpur Express', 'R-101')
ON CONFLICT (id) DO NOTHING;

-- Insert Route Stops
INSERT INTO public.stops (route_id, stop_name, sequence_no, distance_km, lat, lng) VALUES
('22222222-2222-2222-2222-222222222222', 'Jhargram Bus Stand', 1, 0.0, 22.458600, 86.993100),
('22222222-2222-2222-2222-222222222222', 'Lalgarh Stop', 2, 8.0, 22.500000, 86.940000),
('22222222-2222-2222-2222-222222222222', 'Binpur Junction', 3, 15.0, 22.480000, 87.070000),
('22222222-2222-2222-2222-222222222222', 'Sankrail Cross', 4, 32.0, 22.390000, 87.260000),
('22222222-2222-2222-2222-222222222222', 'Kharagpur Central', 5, 56.0, 22.330200, 87.323700)
ON CONFLICT DO NOTHING;

-- Insert Bus
INSERT INTO public.buses (id, route_id, operator_id, bus_number, driver_code, status) VALUES
('33333333-3333-3333-3333-333333333333', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'JGM-01', 'DRV-101', 'active')
ON CONFLICT (id) DO NOTHING;

-- Insert Initial Bus Location
INSERT INTO public.bus_locations (bus_id, lat, lng, trip_status) VALUES
('33333333-3333-3333-3333-333333333333', 22.480000, 87.070000, 'in_progress')
ON CONFLICT (bus_id) DO UPDATE SET
    lat = EXCLUDED.lat,
    lng = EXCLUDED.lng,
    trip_status = EXCLUDED.trip_status,
    updated_at = NOW();
