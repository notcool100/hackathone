using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Module
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Code { get; set; }
        public bool IsActive { get; set; }
        public int DisplayOrder { get; set; }
        public string IconName { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        // Navigation properties
        public ICollection<Menu> Menus { get; set; }
        public ICollection<Permission> Permissions { get; set; }
    }
}