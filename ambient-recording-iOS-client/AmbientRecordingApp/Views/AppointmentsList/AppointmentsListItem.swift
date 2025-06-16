import SwiftUI

/// View for one appointment in list
@MainActor
struct AppointmentsListItem: View {

    let appointment: Appointment
    let recordingState: ActiveRecordingState

    /// Determines if a microphone symbol should be shown on a list item
    var shouldShowMicrophone: Bool {
        switch recordingState {
        case .scheduled,
             .completed:
            return false
        case .recording,
             .paused,
             .cancelled:
            return true
        }
    }

    var body: some View {
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
            .padding()
            if shouldShowMicrophone {
                Image(
                    systemName: AppointmentDetailsViewModel.getMicrophoneImageSystemName(
                        for: recordingState
                    )
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 44, height: 44)
                .padding()
                .foregroundColor(AppointmentDetailsViewModel.getColor(
                    for: recordingState
                ))
            }
            if appointment.hasSynced {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12)
                    .padding(20)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 1) // inset value should be same as lineWidth in .stroke
                .stroke(Color(uiColor: .separator), lineWidth: 1)
        )
    }
}
