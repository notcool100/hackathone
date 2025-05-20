using System;

namespace Domain.Entities
{
    public class RolePermission
    {
        public Guid RoleId { get; set; }
        public Guid PermissionId { get; set; }
        public DateTime AssignedAt { get; set; }
        
        // Navigation properties
        public Role Role { get; set; }
        public Permission Permission { get; set; }
    }
}