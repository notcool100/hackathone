using System;

namespace Domain.Entities
{
    public class MenuPermission
    {
        public Guid MenuId { get; set; }
        public Guid PermissionId { get; set; }
        
        // Navigation properties
        public Menu Menu { get; set; }
        public Permission Permission { get; set; }
    }
}