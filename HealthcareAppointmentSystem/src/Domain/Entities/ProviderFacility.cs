using System;

namespace Domain.Entities
{
    public class ProviderFacility
    {
        public Guid ProviderId { get; set; }
        public Guid FacilityId { get; set; }
        
        // Navigation properties
        public Provider Provider { get; set; }
        public Facility Facility { get; set; }
    }
}