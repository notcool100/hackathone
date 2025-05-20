# Healthcare Appointment System

A blockchain-based healthcare appointment system with integrated payment gateways.

## Features

- Secure appointment booking and management
- Blockchain integration for immutable records
- Payment gateway integration (Esewa and Khalti)
- Real-time notifications
- Smart contract-based appointment agreements
- HIPAA-compliant data handling
- Role-based access control

## Technology Stack

- .NET 7.0
- Entity Framework Core
- SQL Server
- JWT Authentication
- Blockchain Integration
- Payment Gateway Integration
- Swagger/OpenAPI

## Project Structure

```
HealthcareAppointmentSystem/
├── src/
│   ├── HealthcareAppointmentSystem.API/
│   ├── HealthcareAppointmentSystem.Application/
│   ├── HealthcareAppointmentSystem.Domain/
│   └── HealthcareAppointmentSystem.Infrastructure/
└── tests/
    ├── HealthcareAppointmentSystem.UnitTests/
    └── HealthcareAppointmentSystem.IntegrationTests/
```

## Getting Started

### Prerequisites

- .NET 7.0 SDK
- SQL Server
- Docker (optional)
- Node.js (for frontend)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/HealthcareAppointmentSystem.git
```

2. Navigate to the project directory:
```bash
cd HealthcareAppointmentSystem
```

3. Update the connection string in `appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=HealthcareAppointmentSystem;User Id=sa;Password=YourStrong!Passw0rd;TrustServerCertificate=True"
  }
}
```

4. Apply database migrations:
```bash
dotnet ef database update
```

5. Run the application:
```bash
dotnet run --project src/HealthcareAppointmentSystem.API
```

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
# Database
DB_SERVER=localhost
DB_NAME=HealthcareAppointmentSystem
DB_USER=sa
DB_PASSWORD=YourStrong!Passw0rd

# JWT
JWT_SECRET_KEY=your-super-secret-key-with-at-least-32-characters
JWT_ISSUER=HealthcareAppointmentSystem
JWT_AUDIENCE=HealthcareAppointmentSystem
JWT_EXPIRY_MINUTES=60

# Blockchain
BLOCKCHAIN_NETWORK_URL=http://localhost:8545
BLOCKCHAIN_CONTRACT_ADDRESS=your-smart-contract-address

# Payment Gateways
ESEWA_API_KEY=your-esewa-api-key
ESEWA_SECRET_KEY=your-esewa-secret-key
KHALTI_API_KEY=your-khalti-api-key
KHALTI_SECRET_KEY=your-khalti-secret-key
```

## API Documentation

The API documentation is available at `/swagger` when running the application.

### Authentication

The API uses JWT Bearer token authentication. Include the token in the Authorization header:

```
Authorization: Bearer your-jwt-token
```

### Main Endpoints

- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/appointments` - Get all appointments
- `POST /api/appointments` - Create new appointment
- `GET /api/appointments/{id}` - Get appointment by ID
- `PUT /api/appointments/{id}` - Update appointment
- `DELETE /api/appointments/{id}` - Delete appointment
- `POST /api/appointments/{id}/confirm` - Confirm appointment
- `POST /api/appointments/{id}/cancel` - Cancel appointment

## Testing

Run the unit tests:
```bash
dotnet test
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@healthcareappointmentsystem.com or create an issue in the repository.