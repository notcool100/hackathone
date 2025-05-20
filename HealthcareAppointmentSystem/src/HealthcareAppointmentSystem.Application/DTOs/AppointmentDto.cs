using System;

namespace HealthcareAppointmentSystem.Application.DTOs
{
    public class AppointmentDto
    {
        public Guid Id { get; set; }
        public Guid PatientId { get; set; }
        public Guid ProviderId { get; set; }
        public DateTime AppointmentDateTime { get; set; }
        public int DurationMinutes { get; set; }
        public string Status { get; set; }
        public string Type { get; set; }
        public string Notes { get; set; }
        public string SmartContractAddress { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public PaymentDto Payment { get; set; }
        public PatientDto Patient { get; set; }
        public HealthcareProviderDto Provider { get; set; }
    }

    public class CreateAppointmentDto
    {
        public Guid PatientId { get; set; }
        public Guid ProviderId { get; set; }
        public DateTime AppointmentDateTime { get; set; }
        public int DurationMinutes { get; set; }
        public string Type { get; set; }
        public string Notes { get; set; }
    }

    public class UpdateAppointmentDto
    {
        public Guid Id { get; set; }
        public DateTime AppointmentDateTime { get; set; }
        public int DurationMinutes { get; set; }
        public string Type { get; set; }
        public string Notes { get; set; }
    }
} 