import SwiftUI

/**
 # AppointmentDetailsView
 View showing details about an apointment, and recordings associated.
 */
@MainActor
struct AppointmentDetailsView: View {

    @ObservedObject
    var viewModel: AppointmentDetailsViewModel

    var body: some View {
        
        ScrollView {
            VStack {
                if let appointment = viewModel.appointment {
                    AppointDetailsHeaderView(
                        appointment: appointment,
                        recordingState: viewModel.getRecordingState()
                    )

                    Button {
                        viewModel.toggleRecordingState()
                    } label: {
                        Image(systemName: viewModel.microphoneImageSystemName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 88, height: 88)
                            .padding()
                            .foregroundColor(viewModel.microphoneColor)
                    }

                    HStack {
                        Spacer()
                        Button("Pause") {
                            viewModel.pauseRecording()
                        }
                        Spacer()
                        Button("Finish") {
                            viewModel.finishRecording()
                        }
                        Spacer()
                        Button("Cancel") {
                            viewModel.cancelRecording()
                        }
                        Spacer()
                    }
                    .padding(.top)
                }

                ForEach(viewModel.recordings) { recording in
                    RecordingListItem(recording: recording)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
}

/**
 # AppointDetailsHeaderView
 Header view on Appointment details page
 */
struct AppointDetailsHeaderView: View {

    let appointment: Appointment
    let recordingState: ActiveRecordingState

    var body: some View {
        VStack {
            HStack() {
                VStack(alignment: .leading, spacing: 8) {
                    Text(appointment.formattedDate ?? "-")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(appointment.patientName ?? "Untitled")
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("State: \(recordingState.rawValue)")
                        .font(.body)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if appointment.hasSynced {
                    Image(systemName: "checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .padding(.leading)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)

            if let notes = appointment.notes {
                Text(notes)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 12)
            }
        }
        .padding()
    }
}
