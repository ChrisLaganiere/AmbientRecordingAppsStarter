import Foundation

/**
 # OutboxServing
 Protocol for service which publishes pending local changes
 */
@MainActor
protocol OutboxServing {

    /// Enqueue publish for a new recording saved in cache
    func publishRecording(id: Recording.ID) async throws

    /// Enqueue publish for a new appointment saved in cache
    func publishAppointment(id: Appointment.ID) async throws

    /// Enqueue delete for a new appointment saved in cache
    func deleteAppointment(id: Appointment.ID) async throws

    /// Start monitoring network, and publish pending items as soon as network becomes available
    func publishPendingItemsWhenOnline(
        _ networkMonitoringService: any NetworkMonitoring
    )
}
