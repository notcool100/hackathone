using System;
using System.Collections.Generic;
using Domain.Enums;
using Domain.ValueObjects;

namespace Domain.Entities
{
    public class User
    {
        public Guid Id { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string PasswordHash { get; set; }
        public string Name { get; set; }
        public DateTime DateOfBirth { get; set; }
        public Gender Gender { get; set; }
        public string Address { get; set; }
        public string ProfilePicture { get; set; }
        public NotificationPreferences NotificationPreferences { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string BlockchainWalletAddress { get; set; }
        public UserType UserType { get; set; }
        public bool IsActive { get; set; }
        public DateTime? LastLoginAt { get; set; }
        
        // Navigation properties
        public Patient Patient { get; set; }
        public Provider Provider { get; set; }
        public ICollection<Notification> Notifications { get; set; }
        public ICollection<UserRole> UserRoles { get; set; }
        public ICollection<UserSession> UserSessions { get; set; }
    }
}