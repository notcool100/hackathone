using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Facility
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public string ContactInformation { get; set; }
        public string OperatingHours { get; set; }
        public string Services { get; set; }
        public string Amenities { get; set; }
        
        // Navigation properties
        public ICollection<Appointment> Appointments { get; set; }
        public ICollection<Availability> Availabilities { get; set; }
        public ICollection<ProviderFacility> ProviderFacilities { get; set; }
    }
}