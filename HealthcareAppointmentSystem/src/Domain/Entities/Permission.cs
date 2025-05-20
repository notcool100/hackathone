using System;
using System.Collections.Generic;
using Domain.Enums;

namespace Domain.Entities
{
    public class Permission
    {
        public Guid Id { get; set; }
        public Guid ModuleId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public PermissionType Type { get; set; }
        public bool IsActive { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        // Navigation properties
        public Module Module { get; set; }
        public ICollection<RolePermission> RolePermissions { get; set; }
        public ICollection<MenuPermission> MenuPermissions { get; set; }
    }
}