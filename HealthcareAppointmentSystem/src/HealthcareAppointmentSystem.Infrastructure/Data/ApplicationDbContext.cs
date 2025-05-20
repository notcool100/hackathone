using HealthcareAppointmentSystem.Domain.Entities;
using Microsoft.EntityFrameworkCore;

namespace HealthcareAppointmentSystem.Infrastructure.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public DbSet<Patient> Patients { get; set; }
        public DbSet<HealthcareProvider> HealthcareProviders { get; set; }
        public DbSet<Appointment> Appointments { get; set; }
        public DbSet<Payment> Payments { get; set; }
        public DbSet<Schedule> Schedules { get; set; }
        public DbSet<BlockedTimeSlot> BlockedTimeSlots { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Configure User inheritance
            modelBuilder.Entity<User>()
                .HasDiscriminator<string>("UserType")
                .HasValue<Patient>("Patient")
                .HasValue<HealthcareProvider>("HealthcareProvider");

            // Configure Appointment relationships
            modelBuilder.Entity<Appointment>()
                .HasOne(a => a.Patient)
                .WithMany(p => p.Appointments)
                .HasForeignKey(a => a.PatientId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Appointment>()
                .HasOne(a => a.Provider)
                .WithMany(p => p.Appointments)
                .HasForeignKey(a => a.ProviderId)
                .OnDelete(DeleteBehavior.Restrict);

            // Configure Payment relationship
            modelBuilder.Entity<Payment>()
                .HasOne(p => p.Appointment)
                .WithOne(a => a.Payment)
                .HasForeignKey<Payment>(p => p.AppointmentId);

            // Configure Schedule relationship
            modelBuilder.Entity<Schedule>()
                .HasOne(s => s.Provider)
                .WithMany(p => p.Schedules)
                .HasForeignKey(s => s.ProviderId);

            // Configure BlockedTimeSlot relationship
            modelBuilder.Entity<BlockedTimeSlot>()
                .HasOne(b => b.Provider)
                .WithMany(p => p.BlockedTimeSlots)
                .HasForeignKey(b => b.ProviderId);
        }
    }
} 