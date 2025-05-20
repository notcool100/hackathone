# Blockchain-Based Healthcare Appointment System

A secure, transparent appointment booking system for healthcare providers using blockchain technology for immutable record-keeping and smart contracts.

## Project Overview

This system provides:
- Patient and provider portals
- Appointment booking and management
- Blockchain integration for secure records
- Payment processing with local gateways (esewa and khalti)
- Notification system
- Administrative dashboard

## Technology Stack

- **Backend**: .NET 8 (C#)
- **Database**: PostgreSQL
- **Caching**: Redis
- **Blockchain**: Hyperledger Fabric / Ethereum
- **Authentication**: JWT
- **API**: RESTful API with GraphQL support
- **Payment Gateways**: esewa, khalti

## Project Structure

The project follows Clean Architecture principles with the following layers:

```
HealthcareAppointmentSystem/
├── src/
│   ├── Domain/             # Domain entities, value objects, domain events
│   ├── Application/        # Application services, DTOs, interfaces
│   ├── Infrastructure/     # Data access, external services, blockchain
│   └── API/                # API controllers, middleware, configuration
├── tests/
│   ├── Domain.Tests/
│   ├── Application.Tests/
│   ├── Infrastructure.Tests/
│   └── API.Tests/
└── docs/                   # Documentation
```

## Getting Started

### Prerequisites

- .NET 8 SDK
- PostgreSQL
- Redis
- Docker (optional, for containerization)

### Setup Instructions

1. Clone the repository
2. Set up the database:
   ```
   Update connection string in appsettings.json
   Run database migrations: dotnet ef database update
   ```
3. Configure payment gateways:
   ```
   Update payment gateway credentials in appsettings.json
   ```
4. Run the application:
   ```
   dotnet run --project src/API
   ```

## Features

- User authentication and authorization
- Patient and provider management
- Appointment scheduling and management
- Blockchain-based record keeping
- Smart contracts for appointments
- Payment processing with local gateways
- Notification system (email, SMS, push)
- Administrative dashboard
- Reporting and analytics

## API Documentation

API documentation is available at `/swagger` when running the application.

## License

[MIT License](LICENSE)