using System;
using Domain.Enums;

namespace Domain.Entities
{
    public class UserSession
    {
        public Guid Id { get; set; }
        public Guid UserId { get; set; }
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public string IpAddress { get; set; }
        public string DeviceInfo { get; set; }
        public string Browser { get; set; }
        public string OperatingSystem { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime ExpiresAt { get; set; }
        public DateTime? RevokedAt { get; set; }
        public SessionStatus Status { get; set; }
        
        // Navigation properties
        public User User { get; set; }
    }
}