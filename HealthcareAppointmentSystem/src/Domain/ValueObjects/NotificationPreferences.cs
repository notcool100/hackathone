using System;

namespace Domain.ValueObjects
{
    public class NotificationPreferences
    {
        public bool EmailEnabled { get; set; }
        public bool SmsEnabled { get; set; }
        public bool PushEnabled { get; set; }
        public bool AppointmentReminders { get; set; }
        public bool PaymentNotifications { get; set; }
        public bool SystemUpdates { get; set; }
        public int ReminderHoursBefore { get; set; }
    }
}