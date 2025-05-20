using System;
using Domain.Enums;

namespace Domain.Entities
{
    public class Payment
    {
        public Guid Id { get; set; }
        public Guid AppointmentId { get; set; }
        public decimal Amount { get; set; }
        public string Currency { get; set; }
        public PaymentMethod PaymentMethod { get; set; }
        public PaymentStatus Status { get; set; }
        public string TransactionId { get; set; }
        public DateTime PaymentDateTime { get; set; }
        public decimal? RefundAmount { get; set; }
        public string RefundReason { get; set; }
        public string BlockchainTransactionHash { get; set; }
        
        // Navigation properties
        public Appointment Appointment { get; set; }
    }
}