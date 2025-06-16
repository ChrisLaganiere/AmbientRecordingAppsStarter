import SwiftUI

/**
 # AppointmentsList
 List of recent and upcoming appointments
 */
@MainActor
struct AppointmentsList: View {

    @ObservedObject
    var viewModel: AppointmentsListViewModel

    /// Block called when "New" appointment button is tapped
    var onNewAppointmentTap: () -> Void

    /// Block called when an appointment is tapped to select
    var onSelectAppointment: (Appointment.ID) -> Void

    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.appointments) { appointment in
                    Button {
                        onSelectAppointment(appointment.id)
                    } label: {
                        AppointmentsListItem(
                            appointment: appointment,
                            recordingState: viewModel.getRecordingState(
                                for: appointment.appointmentID
                            )
                        )
                    }
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Appointments")
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button("New") {
                    print("New appointment was tapped")
                    onNewAppointmentTap()
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}
