# Healthcare Appointment System Database Schema

This document outlines the normalized database schema (3NF) for the Healthcare Appointment System.

## Normalization Principles Applied

1. **First Normal Form (1NF)**
   - All tables have a primary key
   - No repeating groups
   - All attributes contain atomic values

2. **Second Normal Form (2NF)**
   - Meets 1NF requirements
   - All non-key attributes are fully dependent on the primary key
   - No partial dependencies

3. **Third Normal Form (3NF)**
   - Meets 2NF requirements
   - No transitive dependencies
   - All attributes depend on the key, the whole key, and nothing but the key

## Entity Relationship Diagram

The system uses the following entity relationships:

```
User 1---* UserRole *---1 Role
Role 1---* RolePermission *---1 Permission
Permission *---1 Module
Module 1---* Menu
Menu *---* Permission (via MenuPermission)
User 1---0..1 Patient
User 1---0..1 Provider
Patient 1---* Appointment
Provider 1---* Appointment
Provider 1---* Availability
Facility 1---* Availability
Provider *---* Facility (via ProviderFacility)
Appointment 1---0..1 Payment
User 1---* Notification
User 1---* UserSession
```

## Tables and Relationships

### Core User Management

#### Users
- **Id** (PK): GUID
- **Email**: VARCHAR(255), UNIQUE
- **Phone**: VARCHAR(20)
- **PasswordHash**: VARCHAR(255)
- **Name**: VARCHAR(100)
- **DateOfBirth**: DATE
- **Gender**: ENUM('Male', 'Female', 'Other')
- **Address**: VARCHAR(255)
- **ProfilePicture**: VARCHAR(255)
- **NotificationPreferences**: JSON
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP
- **BlockchainWalletAddress**: VARCHAR(255)
- **UserType**: ENUM('Patient', 'Provider', 'Admin')
- **IsActive**: BOOLEAN
- **LastLoginAt**: TIMESTAMP NULL

#### Roles
- **Id** (PK): GUID
- **Name**: VARCHAR(50), UNIQUE
- **Description**: VARCHAR(255)
- **IsActive**: BOOLEAN
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP

#### UserRoles (Junction Table)
- **UserId** (PK, FK): GUID
- **RoleId** (PK, FK): GUID
- **AssignedAt**: TIMESTAMP

#### Permissions
- **Id** (PK): GUID
- **ModuleId** (FK): GUID
- **Name**: VARCHAR(100)
- **Description**: VARCHAR(255)
- **Code**: VARCHAR(50), UNIQUE
- **Type**: ENUM('View', 'Create', 'Edit', 'Delete', 'Export', 'Import', 'Approve', 'Reject')
- **IsActive**: BOOLEAN
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP

#### RolePermissions (Junction Table)
- **RoleId** (PK, FK): GUID
- **PermissionId** (PK, FK): GUID
- **AssignedAt**: TIMESTAMP

#### Modules
- **Id** (PK): GUID
- **Name**: VARCHAR(50), UNIQUE
- **Description**: VARCHAR(255)
- **Code**: VARCHAR(20), UNIQUE
- **IsActive**: BOOLEAN
- **DisplayOrder**: INT
- **IconName**: VARCHAR(50)
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP

#### Menus
- **Id** (PK): GUID
- **ModuleId** (FK): GUID
- **ParentMenuId** (FK, Self-referencing): GUID NULL
- **Name**: VARCHAR(50)
- **Description**: VARCHAR(255)
- **Url**: VARCHAR(255)
- **IconName**: VARCHAR(50)
- **DisplayOrder**: INT
- **IsActive**: BOOLEAN
- **IsVisible**: BOOLEAN
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP

#### MenuPermissions (Junction Table)
- **MenuId** (PK, FK): GUID
- **PermissionId** (PK, FK): GUID

#### UserSessions
- **Id** (PK): GUID
- **UserId** (FK): GUID
- **Token**: VARCHAR(255)
- **RefreshToken**: VARCHAR(255)
- **IpAddress**: VARCHAR(50)
- **DeviceInfo**: VARCHAR(255)
- **Browser**: VARCHAR(100)
- **OperatingSystem**: VARCHAR(100)
- **CreatedAt**: TIMESTAMP
- **ExpiresAt**: TIMESTAMP
- **RevokedAt**: TIMESTAMP NULL
- **Status**: ENUM('Active', 'Expired', 'Revoked')

#### AuditLogs
- **Id** (PK): GUID
- **UserId** (FK): GUID NULL
- **EntityName**: VARCHAR(50)
- **EntityId**: VARCHAR(50)
- **Action**: ENUM('Create', 'Update', 'Delete', 'Login', 'Logout', 'PasswordChange', 'PasswordReset', 'RoleAssignment', 'PermissionChange')
- **OldValues**: TEXT
- **NewValues**: TEXT
- **IpAddress**: VARCHAR(50)
- **Timestamp**: TIMESTAMP

### Healthcare Domain

#### Patients
- **Id** (PK): GUID
- **UserId** (FK): GUID, UNIQUE
- **MedicalHistory**: TEXT
- **EmergencyContact**: VARCHAR(255)
- **InsuranceInformation**: VARCHAR(255)
- **PreferredLanguage**: VARCHAR(50)
- **Allergies**: TEXT
- **ChronicConditions**: TEXT

#### Providers
- **Id** (PK): GUID
- **UserId** (FK): GUID, UNIQUE
- **Specialization**: VARCHAR(100)
- **Qualifications**: TEXT
- **LicenseNumber**: VARCHAR(50)
- **YearsOfExperience**: INT
- **Biography**: TEXT
- **ConsultationFee**: DECIMAL(10,2)
- **AverageRating**: DECIMAL(3,2)

#### Facilities
- **Id** (PK): GUID
- **Name**: VARCHAR(100)
- **Address**: VARCHAR(255)
- **ContactInformation**: VARCHAR(255)
- **OperatingHours**: VARCHAR(255)
- **Services**: TEXT
- **Amenities**: TEXT

#### ProviderFacilities (Junction Table)
- **ProviderId** (PK, FK): GUID
- **FacilityId** (PK, FK): GUID

#### Availabilities
- **Id** (PK): GUID
- **ProviderId** (FK): GUID
- **FacilityId** (FK): GUID
- **DayOfWeek**: ENUM(0-6)
- **StartTime**: TIME
- **EndTime**: TIME
- **SlotDurationMinutes**: INT
- **IsRecurring**: BOOLEAN
- **SpecificDate**: DATE NULL
- **Status**: ENUM('Available', 'Unavailable', 'Blocked', 'TimeOff')
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP

#### Appointments
- **Id** (PK): GUID
- **PatientId** (FK): GUID
- **ProviderId** (FK): GUID
- **FacilityId** (FK): GUID
- **ScheduledDateTime**: TIMESTAMP
- **Duration**: INT
- **Status**: ENUM('Scheduled', 'Confirmed', 'Completed', 'Canceled', 'NoShow')
- **Type**: ENUM('Initial', 'FollowUp', 'Specialist', 'Emergency', 'Routine')
- **Notes**: TEXT
- **CreatedAt**: TIMESTAMP
- **UpdatedAt**: TIMESTAMP
- **BlockchainTransactionHash**: VARCHAR(255)

#### Payments
- **Id** (PK): GUID
- **AppointmentId** (FK): GUID, UNIQUE
- **Amount**: DECIMAL(10,2)
- **Currency**: VARCHAR(3)
- **PaymentMethod**: ENUM('Esewa', 'Khalti')
- **Status**: ENUM('Pending', 'Completed', 'Failed', 'Refunded', 'PartiallyRefunded')
- **TransactionId**: VARCHAR(100)
- **PaymentDateTime**: TIMESTAMP
- **RefundAmount**: DECIMAL(10,2) NULL
- **RefundReason**: VARCHAR(255) NULL
- **BlockchainTransactionHash**: VARCHAR(255)

#### Notifications
- **Id** (PK): GUID
- **UserId** (FK): GUID
- **Title**: VARCHAR(100)
- **Message**: TEXT
- **Type**: ENUM('AppointmentReminder', 'AppointmentConfirmation', 'AppointmentCancellation', 'PaymentConfirmation', 'PaymentRefund', 'SystemUpdate')
- **IsRead**: BOOLEAN
- **CreatedAt**: TIMESTAMP
- **ReadAt**: TIMESTAMP NULL

## Indexes

### Primary Indexes
- All primary keys have clustered indexes

### Foreign Key Indexes
- All foreign keys have non-clustered indexes

### Performance Indexes
- Users(Email) - For fast login lookups
- Users(Phone) - For fast phone lookups
- Appointments(ScheduledDateTime) - For date range queries
- Appointments(Status) - For filtering by status
- Providers(Specialization) - For searching providers by specialty
- Payments(Status) - For filtering payments by status
- Notifications(UserId, IsRead) - For fetching unread notifications

## Constraints

### Unique Constraints
- Users(Email)
- Roles(Name)
- Permissions(Code)
- Modules(Code)

### Check Constraints
- Appointments(Duration > 0)
- Providers(YearsOfExperience >= 0)
- Providers(ConsultationFee >= 0)
- Providers(AverageRating BETWEEN 0 AND 5)
- Payments(Amount >= 0)
- Payments(RefundAmount <= Amount)

## Normalization Benefits

1. **Reduced Data Redundancy**
   - User information stored only once in Users table
   - Role information stored only once in Roles table
   - Permission information stored only once in Permissions table

2. **Improved Data Integrity**
   - Foreign key constraints ensure referential integrity
   - Junction tables for many-to-many relationships
   - Proper separation of concerns between entities

3. **Flexible Access Control**
   - Role-based permissions system
   - Menu-based navigation with permission checks
   - Module-based organization of system features

4. **Efficient Data Modification**
   - Updates to common data only need to happen in one place
   - Reduced risk of update anomalies
   - Simplified data maintenance

5. **Enhanced Security**
   - Granular permission control
   - Audit logging for all critical operations
   - Session management for tracking user activity