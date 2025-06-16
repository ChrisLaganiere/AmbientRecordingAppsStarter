import Foundation

/**
 # AmbientAPIServing
 Protocol for service which integrates with our server using agreed-upon API contract
 */
protocol AmbientAPIServing: Actor {

    /// Refresh all appointments
    func refreshAppointments() async throws

    /// Publish a new appointment
    func createAppointment(id: Appointment.ID) async throws

    /// Publish a new appointment
    func updateAppointment(id: Appointment.ID) async throws

    /// Get latest updates to an appointment
    func refreshAppointment(id: Appointment.ID) async throws

    /// Destroy an appointment
    func deleteAppointment(id: Appointment.ID) async throws

    /// Refresh all recordings for a particular appointment
    func refreshRecordings(appointmentID: Appointment.ID) async throws

    /// Publish a new recording
    func createRecording(id: Recording.ID) async throws
}
