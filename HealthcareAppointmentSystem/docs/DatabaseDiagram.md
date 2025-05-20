# Healthcare Appointment System Database Diagram

```mermaid
erDiagram
    USERS {
        uuid id PK
        string email UK
        string phone
        string password_hash
        string name
        date date_of_birth
        enum gender
        string address
        string profile_picture
        json notification_preferences
        timestamp created_at
        timestamp updated_at
        string blockchain_wallet_address
        enum user_type
        boolean is_active
        timestamp last_login_at
    }
    
    ROLES {
        uuid id PK
        string name UK
        string description
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    USER_ROLES {
        uuid user_id PK,FK
        uuid role_id PK,FK
        timestamp assigned_at
    }
    
    MODULES {
        uuid id PK
        string name UK
        string description
        string code UK
        boolean is_active
        int display_order
        string icon_name
        timestamp created_at
        timestamp updated_at
    }
    
    PERMISSIONS {
        uuid id PK
        uuid module_id FK
        string name
        string description
        string code UK
        enum type
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    ROLE_PERMISSIONS {
        uuid role_id PK,FK
        uuid permission_id PK,FK
        timestamp assigned_at
    }
    
    MENUS {
        uuid id PK
        uuid module_id FK
        uuid parent_menu_id FK
        string name
        string description
        string url
        string icon_name
        int display_order
        boolean is_active
        boolean is_visible
        timestamp created_at
        timestamp updated_at
    }
    
    MENU_PERMISSIONS {
        uuid menu_id PK,FK
        uuid permission_id PK,FK
    }
    
    USER_SESSIONS {
        uuid id PK
        uuid user_id FK
        string token
        string refresh_token
        string ip_address
        string device_info
        string browser
        string operating_system
        timestamp created_at
        timestamp expires_at
        timestamp revoked_at
        enum status
    }
    
    AUDIT_LOGS {
        uuid id PK
        uuid user_id FK
        string entity_name
        string entity_id
        enum action
        text old_values
        text new_values
        string ip_address
        timestamp timestamp
    }
    
    PATIENTS {
        uuid id PK
        uuid user_id FK,UK
        text medical_history
        string emergency_contact
        string insurance_information
        string preferred_language
        text allergies
        text chronic_conditions
    }
    
    PROVIDERS {
        uuid id PK
        uuid user_id FK,UK
        string specialization
        text qualifications
        string license_number
        int years_of_experience
        text biography
        decimal consultation_fee
        decimal average_rating
    }
    
    FACILITIES {
        uuid id PK
        string name
        string address
        string contact_information
        string operating_hours
        text services
        text amenities
    }
    
    PROVIDER_FACILITIES {
        uuid provider_id PK,FK
        uuid facility_id PK,FK
    }
    
    AVAILABILITIES {
        uuid id PK
        uuid provider_id FK
        uuid facility_id FK
        int day_of_week
        time start_time
        time end_time
        int slot_duration_minutes
        boolean is_recurring
        date specific_date
        enum status
        timestamp created_at
        timestamp updated_at
    }
    
    APPOINTMENTS {
        uuid id PK
        uuid patient_id FK
        uuid provider_id FK
        uuid facility_id FK
        timestamp scheduled_date_time
        int duration
        enum status
        enum type
        text notes
        timestamp created_at
        timestamp updated_at
        string blockchain_transaction_hash
    }
    
    PAYMENTS {
        uuid id PK
        uuid appointment_id FK,UK
        decimal amount
        string currency
        enum payment_method
        enum status
        string transaction_id
        timestamp payment_date_time
        decimal refund_amount
        string refund_reason
        string blockchain_transaction_hash
    }
    
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        string title
        text message
        enum type
        boolean is_read
        timestamp created_at
        timestamp read_at
    }
    
    USERS ||--o{ USER_ROLES : has
    ROLES ||--o{ USER_ROLES : assigned_to
    USERS ||--o{ USER_SESSIONS : has
    USERS ||--o{ AUDIT_LOGS : performs
    USERS ||--o| PATIENTS : is
    USERS ||--o| PROVIDERS : is
    USERS ||--o{ NOTIFICATIONS : receives
    
    ROLES ||--o{ ROLE_PERMISSIONS : has
    PERMISSIONS ||--o{ ROLE_PERMISSIONS : assigned_to
    MODULES ||--o{ PERMISSIONS : contains
    MODULES ||--o{ MENUS : contains
    
    MENUS ||--o{ MENUS : parent_of
    MENUS ||--o{ MENU_PERMISSIONS : has
    PERMISSIONS ||--o{ MENU_PERMISSIONS : assigned_to
    
    PATIENTS ||--o{ APPOINTMENTS : books
    PROVIDERS ||--o{ APPOINTMENTS : conducts
    FACILITIES ||--o{ APPOINTMENTS : hosts
    
    PROVIDERS ||--o{ AVAILABILITIES : sets
    FACILITIES ||--o{ AVAILABILITIES : has
    
    PROVIDERS ||--o{ PROVIDER_FACILITIES : works_at
    FACILITIES ||--o{ PROVIDER_FACILITIES : employs
    
    APPOINTMENTS ||--o| PAYMENTS : has
```

## Schema Visualization

The diagram above illustrates the complete database schema with all entities and their relationships. The schema follows the Third Normal Form (3NF) with proper separation of concerns and elimination of data redundancy.

### Key Features of the Schema:

1. **User Management Subsystem**
   - Users, Roles, and Permissions are properly separated
   - Many-to-many relationships are handled through junction tables
   - Role-based access control is implemented

2. **Menu and Module System**
   - Hierarchical menu structure with parent-child relationships
   - Modules group related functionality
   - Permissions are linked to both menus and roles

3. **Healthcare Domain Entities**
   - Patient and Provider profiles extend the base User entity
   - Appointments connect patients, providers, and facilities
   - Availability management for scheduling

4. **Payment and Notification Systems**
   - Payment tracking with blockchain integration
   - Comprehensive notification system

5. **Security and Auditing**
   - Session management for tracking user activity
   - Detailed audit logging for all operations

This normalized schema provides a solid foundation for the Healthcare Appointment System, ensuring data integrity, reducing redundancy, and supporting all the required functionality.