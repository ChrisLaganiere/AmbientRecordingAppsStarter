import Foundation

/**
 # AmbientAPIService
 Service which integrates with our server using agreed-upon API contract
 */
actor AmbientAPIService: AmbientAPIServing {
    
    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
        /// Controller managing app cache
        let persistenceController: any CoreDataPersisting
    }

    // MARK: Properties

    /// Required dependencies for service
    private let dependencies: Dependencies

    // MARK: Methods

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    /// Refresh all appointments
    func refreshAppointments() async throws {
        try await QueryAppointmentsOperation(
            dependencies: .init(
                apiService: dependencies.apiService,
                persistenceController: dependencies.persistenceController
            )
        ).execute()
    }

    /// Publish a new appointment
    func createAppointment(id: Appointment.ID) async throws {
        try await CreateAppointmentOperation(
            appointmentID: id,
            dependencies: .init(
                apiService: dependencies.apiService,
                persistenceController: dependencies.persistenceController
            )
        ).execute()
    }

    /// Publish a new appointment
    func updateAppointment(id: Appointment.ID) async throws {
        // TODO
    }

    /// Get latest updates to an appointment
    func refreshAppointment(id: Appointment.ID) async throws {
        // TODO
    }

    /// Destroy an appointment
    func deleteAppointment(id: Appointment.ID) async throws {
        // TODO
    }

    /// Refresh all recordings for a particular appointment
    func refreshRecordings(appointmentID: Appointment.ID) async throws {
        try await QueryRecordingsOperation(
            appointmentID: appointmentID,
            dependencies: .init(
                apiService: dependencies.apiService,
                persistenceController: dependencies.persistenceController
            )
        ).execute()
    }

    /// Publish a new recording
    func createRecording(id: Recording.ID) async throws {
        try await CreateRecordingOperation(
            recordingID: id,
            dependencies: .init(
                apiService: dependencies.apiService,
                persistenceController: dependencies.persistenceController
            )
        ).execute()
    }
}
