using System;

namespace Domain.Entities
{
    public class UserRole
    {
        public Guid UserId { get; set; }
        public Guid RoleId { get; set; }
        public DateTime AssignedAt { get; set; }
        
        // Navigation properties
        public User User { get; set; }
        public Role Role { get; set; }
    }
}