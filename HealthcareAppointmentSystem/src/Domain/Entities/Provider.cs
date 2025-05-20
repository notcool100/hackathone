using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Provider
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string Specialization { get; set; }
        public string Qualifications { get; set; }
        public string LicenseNumber { get; set; }
        public int YearsOfExperience { get; set; }
        public string Biography { get; set; }
        public decimal ConsultationFee { get; set; }
        public double AverageRating { get; set; }
        
        // Navigation properties
        public User User { get; set; }
        public ICollection<Appointment> Appointments { get; set; }
        public ICollection<Availability> Availabilities { get; set; }
        public ICollection<ProviderFacility> ProviderFacilities { get; set; }
    }
}