CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS public.operators (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.routes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    operator_id UUID REFERENCES public.operators(id) ON DELETE CASCADE,
    route_name TEXT NOT NULL,
    route_code TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS public.stops (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    stop_name TEXT NOT NULL,
    sequence_no INT NOT NULL,
    distance_km NUMERIC(5,2) DEFAULT 0,
    lat NUMERIC(9,6) NOT NULL,
    lng NUMERIC(9,6) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.buses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    route_id UUID REFERENCES public.routes(id) ON DELETE CASCADE,
    operator_id UUID REFERENCES public.operators(id) ON DELETE CASCADE,
    bus_number TEXT NOT NULL,
    driver_code TEXT UNIQUE NOT NULL,
    driver_password TEXT DEFAULT '1234',
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive'))
);

CREATE TABLE IF NOT EXISTS public.bus_locations (
    bus_id UUID PRIMARY KEY REFERENCES public.buses(id) ON DELETE CASCADE,
    lat NUMERIC(9,6) NOT NULL,
    lng NUMERIC(9,6) NOT NULL,
    last_passed_stop_sequence INT DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    trip_status TEXT DEFAULT 'not_started' CHECK (trip_status IN ('not_started', 'in_progress', 'completed'))
);

ALTER TABLE public.buses ADD COLUMN IF NOT EXISTS driver_password TEXT DEFAULT '1234';
ALTER TABLE public.bus_locations ADD COLUMN IF NOT EXISTS last_passed_stop_sequence INT DEFAULT 0;

ALTER TABLE public.operators ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.buses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bus_locations ENABLE ROW LEVEL SECURITY;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN (
        SELECT policyname, tablename 
        FROM pg_policies 
        WHERE schemaname = 'public' 
        AND tablename IN ('operators', 'routes', 'stops', 'buses', 'bus_locations')
    ) LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', r.policyname, r.tablename);
    END LOOP;
END $$;

CREATE POLICY "operators_all" ON public.operators FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "routes_all" ON public.routes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "stops_all" ON public.stops FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "buses_all" ON public.buses FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "bus_locations_all" ON public.bus_locations FOR ALL USING (true) WITH CHECK (true);

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_publication_tables 
        WHERE pubname = 'supabase_realtime' 
        AND schemaname = 'public' 
        AND tablename = 'bus_locations'
    ) THEN
        ALTER PUBLICATION supabase_realtime ADD TABLE public.bus_locations;
    END IF;
EXCEPTION
    WHEN OTHERS THEN NULL;
END $$;
