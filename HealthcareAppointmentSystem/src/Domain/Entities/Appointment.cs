using System;
using Domain.Enums;

namespace Domain.Entities
{
    public class Appointment
    {
        public Guid Id { get; set; }
        public Guid PatientId { get; set; }
        public Guid ProviderId { get; set; }
        public Guid FacilityId { get; set; }
        public DateTime ScheduledDateTime { get; set; }
        public int Duration { get; set; } // in minutes
        public AppointmentStatus Status { get; set; }
        public AppointmentType Type { get; set; }
        public string Notes { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string BlockchainTransactionHash { get; set; }
        
        // Navigation properties
        public Patient Patient { get; set; }
        public Provider Provider { get; set; }
        public Facility Facility { get; set; }
        public Payment Payment { get; set; }
    }
}