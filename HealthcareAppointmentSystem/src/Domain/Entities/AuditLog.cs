using System;
using Domain.Enums;

namespace Domain.Entities
{
    public class AuditLog
    {
        public Guid Id { get; set; }
        public Guid? UserId { get; set; }
        public string EntityName { get; set; }
        public string EntityId { get; set; }
        public AuditAction Action { get; set; }
        public string OldValues { get; set; }
        public string NewValues { get; set; }
        public string IpAddress { get; set; }
        public DateTime Timestamp { get; set; }
        
        // Navigation properties
        public User User { get; set; }
    }
}