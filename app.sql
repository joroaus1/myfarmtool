
-- ============================================================
-- PHASE 1: FOUNDATION — Utilities & ENUMs
-- ============================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TYPE animal_status AS ENUM ('active', 'sold', 'deceased', 'quarantine');
CREATE TYPE animal_sex AS ENUM ('female', 'male', 'unknown');
CREATE TYPE wellness_type AS ENUM ('vaccination', 'illness', 'treatment', 'checkup', 'surgery', 'deworming', 'other');
CREATE TYPE breeding_method AS ENUM ('natural', 'artificial_insemination', 'embryo_transfer');
CREATE TYPE breeding_outcome AS ENUM ('pending', 'confirmed_pregnant', 'not_pregnant', 'calved', 'miscarried');
CREATE TYPE yield_unit AS ENUM ('liters', 'kg', 'lbs');
CREATE TYPE user_role AS ENUM ('admin', 'manager', 'viewer');

-- ============================================================
-- PHASE 2: DDL — Tables & Indexes
-- ============================================================

-- Profiles table (synced from auth.users)
CREATE TABLE public.profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT,
    full_name TEXT,
    avatar_url TEXT,
    farm_name TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- User roles table
CREATE TABLE public.user_roles (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    role user_role NOT NULL DEFAULT 'viewer',
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(user_id)
);
CREATE INDEX idx_user_roles_user_id ON public.user_roles(user_id);

-- Master animals registry (multi-species)
CREATE TABLE public.animals (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    tag_number VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100),
    species VARCHAR(50) NOT NULL DEFAULT 'cattle',
    breed VARCHAR(100),
    sex animal_sex NOT NULL DEFAULT 'female',
    date_of_birth DATE,
    status animal_status NOT NULL DEFAULT 'active',
    photo_url TEXT,
    weight_at_birth DECIMAL(8,2),
    color VARCHAR(50),
    markings TEXT,
    origin VARCHAR(100),
    purchase_date DATE,
    purchase_price DECIMAL(10,2),
    notes TEXT,
    owner_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_animals_owner_id ON public.animals(owner_id);
CREATE INDEX idx_animals_tag_number ON public.animals(tag_number);
CREATE INDEX idx_animals_species ON public.animals(species);
CREATE INDEX idx_animals_status ON public.animals(status);
CREATE INDEX idx_animals_sex ON public.animals(sex);

-- Genealogy / family tree
CREATE TABLE public.genealogy (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    animal_id UUID NOT NULL,
    sire_id UUID,
    dam_id UUID,
    sire_tag VARCHAR(50),
    dam_tag VARCHAR(50),
    sire_name VARCHAR(100),
    dam_name VARCHAR(100),
    generation_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    UNIQUE(animal_id)
);
CREATE INDEX idx_genealogy_animal_id ON public.genealogy(animal_id);
CREATE INDEX idx_genealogy_sire_id ON public.genealogy(sire_id);
CREATE INDEX idx_genealogy_dam_id ON public.genealogy(dam_id);

-- Wellness / health records
CREATE TABLE public.wellness_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    animal_id UUID NOT NULL,
    record_date DATE NOT NULL DEFAULT CURRENT_DATE,
    wellness_type wellness_type NOT NULL DEFAULT 'checkup',
    title VARCHAR(200) NOT NULL,
    description TEXT,
    vet_name VARCHAR(100),
    vet_clinic VARCHAR(150),
    medication VARCHAR(200),
    dosage VARCHAR(100),
    cost DECIMAL(10,2),
    next_due_date DATE,
    is_resolved BOOLEAN DEFAULT false,
    severity VARCHAR(20) DEFAULT 'low',
    owner_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_wellness_animal_id ON public.wellness_records(animal_id);
CREATE INDEX idx_wellness_owner_id ON public.wellness_records(owner_id);
CREATE INDEX idx_wellness_record_date ON public.wellness_records(record_date);
CREATE INDEX idx_wellness_type ON public.wellness_records(wellness_type);

-- Yield / production records
CREATE TABLE public.yield_records (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    animal_id UUID NOT NULL,
    record_date DATE NOT NULL DEFAULT CURRENT_DATE,
    yield_amount DECIMAL(10,3) NOT NULL,
    yield_unit yield_unit NOT NULL DEFAULT 'liters',
    yield_session VARCHAR(20) DEFAULT 'morning',
    fat_percentage DECIMAL(5,2),
    protein_percentage DECIMAL(5,2),
    somatic_cell_count INTEGER,
    quality_grade VARCHAR(10),
    notes TEXT,
    owner_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_yield_animal_id ON public.yield_records(animal_id);
CREATE INDEX idx_yield_owner_id ON public.yield_records(owner_id);
CREATE INDEX idx_yield_record_date ON public.yield_records(record_date);

-- Breeding & fertility events
CREATE TABLE public.breeding_events (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    dam_id UUID NOT NULL,
    sire_id UUID,
    sire_tag VARCHAR(50),
    sire_name VARCHAR(100),
    breeding_date DATE NOT NULL,
    method breeding_method NOT NULL DEFAULT 'natural',
    outcome breeding_outcome NOT NULL DEFAULT 'pending',
    pregnancy_check_date DATE,
    expected_calving_date DATE,
    actual_calving_date DATE,
    offspring_count INTEGER DEFAULT 0,
    offspring_ids UUID[],
    technician_name VARCHAR(100),
    semen_batch VARCHAR(100),
    cost DECIMAL(10,2),
    notes TEXT,
    owner_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_breeding_dam_id ON public.breeding_events(dam_id);
CREATE INDEX idx_breeding_sire_id ON public.breeding_events(sire_id);
CREATE INDEX idx_breeding_owner_id ON public.breeding_events(owner_id);
CREATE INDEX idx_breeding_date ON public.breeding_events(breeding_date);
CREATE INDEX idx_breeding_outcome ON public.breeding_events(outcome);

-- Measurements & growth tracking
CREATE TABLE public.measurements (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    animal_id UUID NOT NULL,
    measurement_date DATE NOT NULL DEFAULT CURRENT_DATE,
    weight DECIMAL(8,2),
    weight_unit VARCHAR(10) DEFAULT 'kg',
    height_withers DECIMAL(6,2),
    body_length DECIMAL(6,2),
    girth DECIMAL(6,2),
    hip_width DECIMAL(6,2),
    body_condition_score DECIMAL(3,1),
    heart_girth DECIMAL(6,2),
    age_days INTEGER,
    average_daily_gain DECIMAL(6,3),
    notes TEXT,
    measured_by VARCHAR(100),
    owner_id UUID NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX idx_measurements_animal_id ON public.measurements(animal_id);
CREATE INDEX idx_measurements_owner_id ON public.measurements(owner_id);
CREATE INDEX idx_measurements_date ON public.measurements(measurement_date);

-- ============================================================
-- PHASE 3: LOGIC — Table-Dependent Functions
-- ============================================================

CREATE OR REPLACE FUNCTION public.has_role(_role user_role)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid()
    AND role = _role
  );
$$;

CREATE OR REPLACE FUNCTION public.is_admin_or_manager()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = public
STABLE
AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_roles
    WHERE user_id = auth.uid()
    AND role IN ('admin', 'manager')
  );
$$;

-- ============================================================
-- PHASE 4: SECURITY — RLS Policies
-- ============================================================

-- Profiles RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile" ON public.profiles
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.profiles
    FOR UPDATE USING (auth.uid() = id);

-- User roles RLS
ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own role" ON public.user_roles
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Admins can manage all roles" ON public.user_roles
    FOR ALL USING (has_role('admin'));

-- Animals RLS
ALTER TABLE public.animals ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own animals" ON public.animals
    FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Admins and managers can insert animals" ON public.animals
    FOR INSERT WITH CHECK (auth.uid() = owner_id AND is_admin_or_manager());

CREATE POLICY "Admins and managers can update animals" ON public.animals
    FOR UPDATE USING (auth.uid() = owner_id AND is_admin_or_manager());

CREATE POLICY "Admins can delete animals" ON public.animals
    FOR DELETE USING (auth.uid() = owner_id AND has_role('admin'));

-- Genealogy RLS
ALTER TABLE public.genealogy ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view genealogy for own animals" ON public.genealogy
    FOR SELECT USING (
        EXISTS (SELECT 1 FROM public.animals WHERE id = genealogy.animal_id AND owner_id = auth.uid())
    );

CREATE POLICY "Managers can manage genealogy" ON public.genealogy
    FOR ALL USING (
        EXISTS (SELECT 1 FROM public.animals WHERE id = genealogy.animal_id AND owner_id = auth.uid())
        AND is_admin_or_manager()
    );

-- Wellness records RLS
ALTER TABLE public.wellness_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wellness records" ON public.wellness_records
    FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Managers can manage wellness records" ON public.wellness_records
    FOR ALL USING (auth.uid() = owner_id AND is_admin_or_manager());

-- Yield records RLS
ALTER TABLE public.yield_records ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own yield records" ON public.yield_records
    FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Managers can manage yield records" ON public.yield_records
    FOR ALL USING (auth.uid() = owner_id AND is_admin_or_manager());

-- Breeding events RLS
ALTER TABLE public.breeding_events ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own breeding events" ON public.breeding_events
    FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Managers can manage breeding events" ON public.breeding_events
    FOR ALL USING (auth.uid() = owner_id AND is_admin_or_manager());

-- Measurements RLS
ALTER TABLE public.measurements ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own measurements" ON public.measurements
    FOR SELECT USING (auth.uid() = owner_id);

CREATE POLICY "Managers can manage measurements" ON public.measurements
    FOR ALL USING (auth.uid() = owner_id AND is_admin_or_manager());

-- ============================================================
-- PHASE 5: AUTOMATION — Triggers
-- ============================================================

-- Timestamp triggers
CREATE TRIGGER update_profiles_updated_at
    BEFORE UPDATE ON public.profiles
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_user_roles_updated_at
    BEFORE UPDATE ON public.user_roles
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_animals_updated_at
    BEFORE UPDATE ON public.animals
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_genealogy_updated_at
    BEFORE UPDATE ON public.genealogy
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_wellness_updated_at
    BEFORE UPDATE ON public.wellness_records
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_yield_updated_at
    BEFORE UPDATE ON public.yield_records
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_breeding_updated_at
    BEFORE UPDATE ON public.breeding_events
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_measurements_updated_at
    BEFORE UPDATE ON public.measurements
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- New user sync trigger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER SET search_path = public
AS $$
BEGIN
    INSERT INTO public.profiles (id, email, full_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.email)
    );

    INSERT INTO public.user_roles (user_id, role)
    VALUES (NEW.id, 'admin');

    RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
