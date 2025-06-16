import SwiftUI

/// View for one recording in list
@MainActor
struct RecordingListItem: View {

    let recording: Recording

    var body: some View {
        HStack() {
            VStack(alignment: .leading, spacing: 8) {
                Text(recording.formattedDate ?? "-")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color(uiColor: .secondaryLabel))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Duration: \(recording.duration)")
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            if recording.hasSynced {
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
