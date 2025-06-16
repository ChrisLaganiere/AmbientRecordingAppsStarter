import SwiftUI
import CoreData

@MainActor
struct ContentView: View {

    /// Data-layer services
    let dependencies: AmbientRecordingAppDataDependencies

    /// Used for programmatically changing navigation stack
    @State private var navigationStack: [Appointment.ID] = []

    init(dependencies: AmbientRecordingAppDataDependencies) {
        self.dependencies = dependencies
    }

    var body: some View {
        NavigationStack(path: $navigationStack) {
            AppointmentsList(
                viewModel: .init(
                    moc: dependencies.persistenceController.viewContext,
                    audioRecordingService: dependencies.audioRecordingService
                ),
                onNewAppointmentTap: {
                    // Create a new appointment pre-filled with info, for demo!
                    Appointment.publishRandomAppointment(
                        in: dependencies.persistenceController,
                        outbox: dependencies.outboxService
                    )
                },
                onSelectAppointment: { appointmentID in
                    // Navigate to appointment
                    navigationStack.append(appointmentID)
                }
            )
            .navigationDestination(for: Appointment.ID.self) { appointmentID in
                AppointmentDetailsView(
                    viewModel: .init(
                        appointmentID: appointmentID,
                        moc: dependencies.persistenceController.viewContext,
                        audioRecordingService: dependencies.audioRecordingService
                    )
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
