using HealthcareAppointmentSystem.Application.DTOs;

namespace HealthcareAppointmentSystem.Application.Interfaces
{
    public interface IAppointmentService
    {
        Task<IEnumerable<AppointmentDto>> GetAllAppointmentsAsync();
        Task<AppointmentDto> GetAppointmentByIdAsync(Guid id);
        Task<AppointmentDto> CreateAppointmentAsync(CreateAppointmentDto appointmentDto);
        Task<bool> UpdateAppointmentAsync(UpdateAppointmentDto appointmentDto);
        Task<bool> DeleteAppointmentAsync(Guid id);
        Task<bool> ConfirmAppointmentAsync(Guid id);
        Task<bool> CancelAppointmentAsync(Guid id);
        Task<IEnumerable<AppointmentDto>> GetPatientAppointmentsAsync(Guid patientId);
        Task<IEnumerable<AppointmentDto>> GetProviderAppointmentsAsync(Guid providerId);
        Task<bool> RescheduleAppointmentAsync(Guid id, DateTime newDateTime);
    }
} 