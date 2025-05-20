-- Healthcare Appointment System Database Migration Script
-- Normalized to 3NF

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create ENUM types
CREATE TYPE gender_type AS ENUM ('Male', 'Female', 'Other');
CREATE TYPE user_type AS ENUM ('Patient', 'Provider', 'Admin');
CREATE TYPE appointment_status AS ENUM ('Scheduled', 'Confirmed', 'Completed', 'Canceled', 'NoShow');
CREATE TYPE appointment_type AS ENUM ('Initial', 'FollowUp', 'Specialist', 'Emergency', 'Routine');
CREATE TYPE payment_method AS ENUM ('Esewa', 'Khalti');
CREATE TYPE payment_status AS ENUM ('Pending', 'Completed', 'Failed', 'Refunded', 'PartiallyRefunded');
CREATE TYPE notification_type AS ENUM ('AppointmentReminder', 'AppointmentConfirmation', 'AppointmentCancellation', 'PaymentConfirmation', 'PaymentRefund', 'SystemUpdate');
CREATE TYPE permission_type AS ENUM ('View', 'Create', 'Edit', 'Delete', 'Export', 'Import', 'Approve', 'Reject');
CREATE TYPE session_status AS ENUM ('Active', 'Expired', 'Revoked');
CREATE TYPE availability_status AS ENUM ('Available', 'Unavailable', 'Blocked', 'TimeOff');
CREATE TYPE audit_action AS ENUM ('Create', 'Update', 'Delete', 'Login', 'Logout', 'PasswordChange', 'PasswordReset', 'RoleAssignment', 'PermissionChange');

-- Create Tables

-- Core User Management

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    gender gender_type,
    address VARCHAR(255),
    profile_picture VARCHAR(255),
    notification_preferences JSONB,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    blockchain_wallet_address VARCHAR(255),
    user_type user_type NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    last_login_at TIMESTAMP
);

-- Roles Table
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- UserRoles Junction Table
CREATE TABLE user_roles (
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Modules Table
CREATE TABLE modules (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    code VARCHAR(20) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    display_order INT NOT NULL DEFAULT 0,
    icon_name VARCHAR(50),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Permissions Table
CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    code VARCHAR(50) NOT NULL UNIQUE,
    type permission_type NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE
);

-- RolePermissions Junction Table
CREATE TABLE role_permissions (
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    assigned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- Menus Table
CREATE TABLE menus (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    module_id UUID NOT NULL,
    parent_menu_id UUID,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255),
    url VARCHAR(255),
    icon_name VARCHAR(50),
    display_order INT NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_visible BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (module_id) REFERENCES modules(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_menu_id) REFERENCES menus(id) ON DELETE SET NULL
);

-- MenuPermissions Junction Table
CREATE TABLE menu_permissions (
    menu_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    PRIMARY KEY (menu_id, permission_id),
    FOREIGN KEY (menu_id) REFERENCES menus(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
);

-- UserSessions Table
CREATE TABLE user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    token VARCHAR(255) NOT NULL,
    refresh_token VARCHAR(255) NOT NULL,
    ip_address VARCHAR(50),
    device_info VARCHAR(255),
    browser VARCHAR(100),
    operating_system VARCHAR(100),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    revoked_at TIMESTAMP,
    status session_status NOT NULL DEFAULT 'Active',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- AuditLogs Table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,
    entity_name VARCHAR(50) NOT NULL,
    entity_id VARCHAR(50) NOT NULL,
    action audit_action NOT NULL,
    old_values TEXT,
    new_values TEXT,
    ip_address VARCHAR(50),
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- Healthcare Domain

-- Patients Table
CREATE TABLE patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE,
    medical_history TEXT,
    emergency_contact VARCHAR(255),
    insurance_information VARCHAR(255),
    preferred_language VARCHAR(50),
    allergies TEXT,
    chronic_conditions TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Providers Table
CREATE TABLE providers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL UNIQUE,
    specialization VARCHAR(100),
    qualifications TEXT,
    license_number VARCHAR(50),
    years_of_experience INT NOT NULL DEFAULT 0,
    biography TEXT,
    consultation_fee DECIMAL(10,2) NOT NULL DEFAULT 0,
    average_rating DECIMAL(3,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT check_years_experience CHECK (years_of_experience >= 0),
    CONSTRAINT check_consultation_fee CHECK (consultation_fee >= 0),
    CONSTRAINT check_average_rating CHECK (average_rating BETWEEN 0 AND 5)
);

-- Facilities Table
CREATE TABLE facilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    contact_information VARCHAR(255),
    operating_hours VARCHAR(255),
    services TEXT,
    amenities TEXT
);

-- ProviderFacilities Junction Table
CREATE TABLE provider_facilities (
    provider_id UUID NOT NULL,
    facility_id UUID NOT NULL,
    PRIMARY KEY (provider_id, facility_id),
    FOREIGN KEY (provider_id) REFERENCES providers(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE
);

-- Availabilities Table
CREATE TABLE availabilities (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    provider_id UUID NOT NULL,
    facility_id UUID NOT NULL,
    day_of_week INT NOT NULL, -- 0 = Sunday, 6 = Saturday
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    slot_duration_minutes INT NOT NULL DEFAULT 30,
    is_recurring BOOLEAN NOT NULL DEFAULT TRUE,
    specific_date DATE,
    status availability_status NOT NULL DEFAULT 'Available',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (provider_id) REFERENCES providers(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE,
    CONSTRAINT check_day_of_week CHECK (day_of_week BETWEEN 0 AND 6),
    CONSTRAINT check_time_range CHECK (start_time < end_time),
    CONSTRAINT check_slot_duration CHECK (slot_duration_minutes > 0)
);

-- Appointments Table
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID NOT NULL,
    provider_id UUID NOT NULL,
    facility_id UUID NOT NULL,
    scheduled_date_time TIMESTAMP NOT NULL,
    duration INT NOT NULL, -- in minutes
    status appointment_status NOT NULL DEFAULT 'Scheduled',
    type appointment_type NOT NULL,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    blockchain_transaction_hash VARCHAR(255),
    FOREIGN KEY (patient_id) REFERENCES patients(id) ON DELETE CASCADE,
    FOREIGN KEY (provider_id) REFERENCES providers(id) ON DELETE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES facilities(id) ON DELETE CASCADE,
    CONSTRAINT check_duration CHECK (duration > 0)
);

-- Payments Table
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    appointment_id UUID NOT NULL UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'NPR',
    payment_method payment_method NOT NULL,
    status payment_status NOT NULL DEFAULT 'Pending',
    transaction_id VARCHAR(100),
    payment_date_time TIMESTAMP,
    refund_amount DECIMAL(10,2),
    refund_reason VARCHAR(255),
    blockchain_transaction_hash VARCHAR(255),
    FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    CONSTRAINT check_amount CHECK (amount >= 0),
    CONSTRAINT check_refund_amount CHECK (refund_amount IS NULL OR (refund_amount >= 0 AND refund_amount <= amount))
);

-- Notifications Table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    type notification_type NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create Indexes

-- Users Indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_user_type ON users(user_type);

-- UserRoles Indexes
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);

-- Permissions Indexes
CREATE INDEX idx_permissions_module_id ON permissions(module_id);
CREATE INDEX idx_permissions_code ON permissions(code);

-- RolePermissions Indexes
CREATE INDEX idx_role_permissions_role_id ON role_permissions(role_id);
CREATE INDEX idx_role_permissions_permission_id ON role_permissions(permission_id);

-- Menus Indexes
CREATE INDEX idx_menus_module_id ON menus(module_id);
CREATE INDEX idx_menus_parent_menu_id ON menus(parent_menu_id);

-- MenuPermissions Indexes
CREATE INDEX idx_menu_permissions_menu_id ON menu_permissions(menu_id);
CREATE INDEX idx_menu_permissions_permission_id ON menu_permissions(permission_id);

-- UserSessions Indexes
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);
CREATE INDEX idx_user_sessions_token ON user_sessions(token);
CREATE INDEX idx_user_sessions_status ON user_sessions(status);

-- AuditLogs Indexes
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_entity_name ON audit_logs(entity_name);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);

-- Patients Indexes
CREATE INDEX idx_patients_user_id ON patients(user_id);

-- Providers Indexes
CREATE INDEX idx_providers_user_id ON providers(user_id);
CREATE INDEX idx_providers_specialization ON providers(specialization);

-- ProviderFacilities Indexes
CREATE INDEX idx_provider_facilities_provider_id ON provider_facilities(provider_id);
CREATE INDEX idx_provider_facilities_facility_id ON provider_facilities(facility_id);

-- Availabilities Indexes
CREATE INDEX idx_availabilities_provider_id ON availabilities(provider_id);
CREATE INDEX idx_availabilities_facility_id ON availabilities(facility_id);
CREATE INDEX idx_availabilities_day_of_week ON availabilities(day_of_week);
CREATE INDEX idx_availabilities_specific_date ON availabilities(specific_date);
CREATE INDEX idx_availabilities_status ON availabilities(status);

-- Appointments Indexes
CREATE INDEX idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX idx_appointments_provider_id ON appointments(provider_id);
CREATE INDEX idx_appointments_facility_id ON appointments(facility_id);
CREATE INDEX idx_appointments_scheduled_date_time ON appointments(scheduled_date_time);
CREATE INDEX idx_appointments_status ON appointments(status);

-- Payments Indexes
CREATE INDEX idx_payments_appointment_id ON payments(appointment_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_payment_method ON payments(payment_method);

-- Notifications Indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_user_id_is_read ON notifications(user_id, is_read);

-- Insert Default Data

-- Default Roles
INSERT INTO roles (id, name, description, is_active)
VALUES 
    (uuid_generate_v4(), 'Admin', 'System Administrator with full access', TRUE),
    (uuid_generate_v4(), 'Provider', 'Healthcare Provider', TRUE),
    (uuid_generate_v4(), 'Patient', 'Patient User', TRUE),
    (uuid_generate_v4(), 'Receptionist', 'Front Desk Staff', TRUE);

-- Default Modules
INSERT INTO modules (id, name, description, code, is_active, display_order, icon_name)
VALUES
    (uuid_generate_v4(), 'Dashboard', 'System Dashboard', 'DASHBOARD', TRUE, 1, 'dashboard'),
    (uuid_generate_v4(), 'User Management', 'User and Role Management', 'USER_MGMT', TRUE, 2, 'people'),
    (uuid_generate_v4(), 'Appointments', 'Appointment Management', 'APPOINTMENTS', TRUE, 3, 'calendar'),
    (uuid_generate_v4(), 'Patients', 'Patient Management', 'PATIENTS', TRUE, 4, 'person'),
    (uuid_generate_v4(), 'Providers', 'Provider Management', 'PROVIDERS', TRUE, 5, 'medical_services'),
    (uuid_generate_v4(), 'Facilities', 'Facility Management', 'FACILITIES', TRUE, 6, 'business'),
    (uuid_generate_v4(), 'Payments', 'Payment Management', 'PAYMENTS', TRUE, 7, 'payments'),
    (uuid_generate_v4(), 'Reports', 'Reports and Analytics', 'REPORTS', TRUE, 8, 'analytics'),
    (uuid_generate_v4(), 'Settings', 'System Settings', 'SETTINGS', TRUE, 9, 'settings');

-- Create Triggers for Updated_At timestamps

-- Users Updated_At Trigger
CREATE OR REPLACE FUNCTION update_users_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_users_updated_at();

-- Roles Updated_At Trigger
CREATE OR REPLACE FUNCTION update_roles_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_roles_updated_at
BEFORE UPDATE ON roles
FOR EACH ROW
EXECUTE FUNCTION update_roles_updated_at();

-- Modules Updated_At Trigger
CREATE OR REPLACE FUNCTION update_modules_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_modules_updated_at
BEFORE UPDATE ON modules
FOR EACH ROW
EXECUTE FUNCTION update_modules_updated_at();

-- Permissions Updated_At Trigger
CREATE OR REPLACE FUNCTION update_permissions_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_permissions_updated_at
BEFORE UPDATE ON permissions
FOR EACH ROW
EXECUTE FUNCTION update_permissions_updated_at();

-- Menus Updated_At Trigger
CREATE OR REPLACE FUNCTION update_menus_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_menus_updated_at
BEFORE UPDATE ON menus
FOR EACH ROW
EXECUTE FUNCTION update_menus_updated_at();

-- Appointments Updated_At Trigger
CREATE OR REPLACE FUNCTION update_appointments_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_appointments_updated_at
BEFORE UPDATE ON appointments
FOR EACH ROW
EXECUTE FUNCTION update_appointments_updated_at();

-- Availabilities Updated_At Trigger
CREATE OR REPLACE FUNCTION update_availabilities_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_availabilities_updated_at
BEFORE UPDATE ON availabilities
FOR EACH ROW
EXECUTE FUNCTION update_availabilities_updated_at();