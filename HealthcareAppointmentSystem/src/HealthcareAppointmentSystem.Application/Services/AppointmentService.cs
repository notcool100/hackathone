using HealthcareAppointmentSystem.Application.DTOs;
using HealthcareAppointmentSystem.Application.Interfaces;
using HealthcareAppointmentSystem.Domain.Entities;
using HealthcareAppointmentSystem.Infrastructure.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace HealthcareAppointmentSystem.Application.Services
{
    public class AppointmentService : IAppointmentService
    {
        private readonly IUnitOfWork _unitOfWork;
        private readonly IBlockchainService _blockchainService;
        private readonly INotificationService _notificationService;

        public AppointmentService(
            IUnitOfWork unitOfWork,
            IBlockchainService blockchainService,
            INotificationService notificationService)
        {
            _unitOfWork = unitOfWork;
            _blockchainService = blockchainService;
            _notificationService = notificationService;
        }

        public async Task<IEnumerable<AppointmentDto>> GetAllAppointmentsAsync()
        {
            var appointments = await _unitOfWork.Appointments.GetAll()
                .Include(a => a.Patient)
                .Include(a => a.Provider)
                .Include(a => a.Payment)
                .ToListAsync();

            return appointments.Select(MapToDto);
        }

        public async Task<AppointmentDto> GetAppointmentByIdAsync(Guid id)
        {
            var appointment = await _unitOfWork.Appointments.GetAll()
                .Include(a => a.Patient)
                .Include(a => a.Provider)
                .Include(a => a.Payment)
                .FirstOrDefaultAsync(a => a.Id == id);

            return appointment != null ? MapToDto(appointment) : null;
        }

        public async Task<AppointmentDto> CreateAppointmentAsync(CreateAppointmentDto appointmentDto)
        {
            var appointment = new Appointment
            {
                PatientId = appointmentDto.PatientId,
                ProviderId = appointmentDto.ProviderId,
                AppointmentDateTime = appointmentDto.AppointmentDateTime,
                DurationMinutes = appointmentDto.DurationMinutes,
                Type = appointmentDto.Type,
                Notes = appointmentDto.Notes,
                Status = "Scheduled",
                CreatedAt = DateTime.UtcNow
            };

            // Create smart contract for the appointment
            appointment.SmartContractAddress = await _blockchainService.CreateAppointmentContractAsync(appointment);

            await _unitOfWork.Appointments.AddAsync(appointment);
            await _unitOfWork.SaveChangesAsync();

            // Send notification
            await _notificationService.SendAppointmentCreatedNotificationAsync(appointment);

            return await GetAppointmentByIdAsync(appointment.Id);
        }

        public async Task<bool> UpdateAppointmentAsync(UpdateAppointmentDto appointmentDto)
        {
            var appointment = await _unitOfWork.Appointments.GetByIdAsync(appointmentDto.Id);
            if (appointment == null)
                return false;

            appointment.AppointmentDateTime = appointmentDto.AppointmentDateTime;
            appointment.DurationMinutes = appointmentDto.DurationMinutes;
            appointment.Type = appointmentDto.Type;
            appointment.Notes = appointmentDto.Notes;
            appointment.UpdatedAt = DateTime.UtcNow;

            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAppointmentAsync(Guid id)
        {
            var appointment = await _unitOfWork.Appointments.GetByIdAsync(id);
            if (appointment == null)
                return false;

            await _unitOfWork.Appointments.DeleteAsync(appointment);
            await _unitOfWork.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ConfirmAppointmentAsync(Guid id)
        {
            var appointment = await _unitOfWork.Appointments.GetByIdAsync(id);
            if (appointment == null)
                return false;

            appointment.Status = "Confirmed";
            appointment.UpdatedAt = DateTime.UtcNow;

            await _unitOfWork.SaveChangesAsync();
            await _notificationService.SendAppointmentConfirmedNotificationAsync(appointment);
            return true;
        }

        public async Task<bool> CancelAppointmentAsync(Guid id)
        {
            var appointment = await _unitOfWork.Appointments.GetByIdAsync(id);
            if (appointment == null)
                return false;

            appointment.Status = "Cancelled";
            appointment.UpdatedAt = DateTime.UtcNow;

            await _unitOfWork.SaveChangesAsync();
            await _notificationService.SendAppointmentCancelledNotificationAsync(appointment);
            return true;
        }

        public async Task<IEnumerable<AppointmentDto>> GetPatientAppointmentsAsync(Guid patientId)
        {
            var appointments = await _unitOfWork.Appointments.GetAll()
                .Include(a => a.Patient)
                .Include(a => a.Provider)
                .Include(a => a.Payment)
                .Where(a => a.PatientId == patientId)
                .ToListAsync();

            return appointments.Select(MapToDto);
        }

        public async Task<IEnumerable<AppointmentDto>> GetProviderAppointmentsAsync(Guid providerId)
        {
            var appointments = await _unitOfWork.Appointments.GetAll()
                .Include(a => a.Patient)
                .Include(a => a.Provider)
                .Include(a => a.Payment)
                .Where(a => a.ProviderId == providerId)
                .ToListAsync();

            return appointments.Select(MapToDto);
        }

        public async Task<bool> RescheduleAppointmentAsync(Guid id, DateTime newDateTime)
        {
            var appointment = await _unitOfWork.Appointments.GetByIdAsync(id);
            if (appointment == null)
                return false;

            appointment.AppointmentDateTime = newDateTime;
            appointment.UpdatedAt = DateTime.UtcNow;

            await _unitOfWork.SaveChangesAsync();
            await _notificationService.SendAppointmentRescheduledNotificationAsync(appointment);
            return true;
        }

        private static AppointmentDto MapToDto(Appointment appointment)
        {
            return new AppointmentDto
            {
                Id = appointment.Id,
                PatientId = appointment.PatientId,
                ProviderId = appointment.ProviderId,
                AppointmentDateTime = appointment.AppointmentDateTime,
                DurationMinutes = appointment.DurationMinutes,
                Status = appointment.Status,
                Type = appointment.Type,
                Notes = appointment.Notes,
                SmartContractAddress = appointment.SmartContractAddress,
                CreatedAt = appointment.CreatedAt,
                UpdatedAt = appointment.UpdatedAt,
                Payment = appointment.Payment != null ? new PaymentDto
                {
                    Id = appointment.Payment.Id,
                    Amount = appointment.Payment.Amount,
                    Status = appointment.Payment.Status,
                    PaymentMethod = appointment.Payment.PaymentMethod,
                    TransactionId = appointment.Payment.TransactionId
                } : null,
                Patient = appointment.Patient != null ? new PatientDto
                {
                    Id = appointment.Patient.Id,
                    FirstName = appointment.Patient.FirstName,
                    LastName = appointment.Patient.LastName,
                    Email = appointment.Patient.Email,
                    PhoneNumber = appointment.Patient.PhoneNumber
                } : null,
                Provider = appointment.Provider != null ? new HealthcareProviderDto
                {
                    Id = appointment.Provider.Id,
                    FirstName = appointment.Provider.FirstName,
                    LastName = appointment.Provider.LastName,
                    Specialization = appointment.Provider.Specialization
                } : null
            };
        }
    }
} 