using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Patient
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string MedicalHistory { get; set; }
        public string EmergencyContact { get; set; }
        public string InsuranceInformation { get; set; }
        public string PreferredLanguage { get; set; }
        public string Allergies { get; set; }
        public string ChronicConditions { get; set; }
        
        // Navigation properties
        public User User { get; set; }
        public ICollection<Appointment> Appointments { get; set; }
    }
}