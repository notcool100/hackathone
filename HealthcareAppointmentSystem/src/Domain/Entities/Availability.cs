using System;
using Domain.Enums;

namespace Domain.Entities
{
    public class Availability
    {
        public Guid Id { get; set; }
        public Guid ProviderId { get; set; }
        public Guid FacilityId { get; set; }
        public DayOfWeek DayOfWeek { get; set; }
        public TimeSpan StartTime { get; set; }
        public TimeSpan EndTime { get; set; }
        public int SlotDurationMinutes { get; set; }
        public bool IsRecurring { get; set; }
        public DateTime? SpecificDate { get; set; }
        public AvailabilityStatus Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        // Navigation properties
        public Provider Provider { get; set; }
        public Facility Facility { get; set; }
    }
}