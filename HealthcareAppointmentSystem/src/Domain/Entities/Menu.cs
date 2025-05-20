using System;
using System.Collections.Generic;

namespace Domain.Entities
{
    public class Menu
    {
        public Guid Id { get; set; }
        public Guid ModuleId { get; set; }
        public Guid? ParentMenuId { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string Url { get; set; }
        public string IconName { get; set; }
        public int DisplayOrder { get; set; }
        public bool IsActive { get; set; }
        public bool IsVisible { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        
        // Navigation properties
        public Module Module { get; set; }
        public Menu ParentMenu { get; set; }
        public ICollection<Menu> ChildMenus { get; set; }
        public ICollection<MenuPermission> MenuPermissions { get; set; }
    }
}