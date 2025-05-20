using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Role
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        // Navigation properties
        public ICollection<UserRole> UserRoles { get; set; }
        public ICollection<RolePermission> RolePermissions { get; set; }
    }
}