import CoreData
import SwiftUI

/**
 # AppointmentDetailsViewModel
 View model for `AppointmentDetailsView`.
 */
@MainActor
final class AppointmentDetailsViewModel: ObservableObject {

    /// Identifier for active selected entity
    let appointmentID: Appointment.ID

    /// Info about the current recording session status
    @Published
    private(set) var activeRecording: ActiveRecording?

    /// Publisher for appointment entities
    @Published private(set) var appointment: Appointment?

    /// Publisher for appointment entities
    @Published private(set) var recordings: [Recording] = []

    /// Color of microphone on page
    var microphoneColor: Color {
        AppointmentDetailsViewModel.getColor(
            for: getRecordingState()
        )
    }

    /// Color of microphone on page
    var microphoneImageSystemName: String {
        AppointmentDetailsViewModel.getMicrophoneImageSystemName(
            for: getRecordingState()
        )
    }

    // MARK: Private Properties

    /// Controller fetching for appointment entities, and publishing updates as they are saved to the app cache
    private let appointmentsPublisher: FetchableResultsPublisher<Appointment>

    /// Controller fetching for recording entities, and publishing updates as they are saved to the app cache
    private let recordingsPublisher: FetchableResultsPublisher<Recording>

    /// Service recording audio and saving recordings to cache
    private let audioRecordingService: any AudioRecording

    init(
        appointmentID: Appointment.ID,
        moc: NSManagedObjectContext,
        audioRecordingService: any AudioRecording
    ) {
        self.appointmentID = appointmentID
        self.audioRecordingService = audioRecordingService
        self.appointmentsPublisher = FetchableResultsPublisher(
            filter: .appointmentID(appointmentID),
            sort: .start,
            moc: moc
        )
        self.recordingsPublisher = FetchableResultsPublisher(
            filter: .appointmentID(appointmentID),
            sort: .start,
            moc: moc
        )

        // Assign fetched results to view model property
        try? appointmentsPublisher.beginFetch()
        appointmentsPublisher.fetchedObjectsPublisher
            .eraseToAnyPublisher()
            .map(\.first)
            .assign(to: &$appointment)
        try? recordingsPublisher.beginFetch()
        recordingsPublisher.fetchedObjectsPublisher
            .eraseToAnyPublisher()
            .assign(to: &$recordings)

        // Assign recording session status to view model property
        audioRecordingService.activeRecordingPublisher.assign(to: &$activeRecording)
    }

    /// Called when microphone symbol is tapped
    func toggleRecordingState() {
        // Special case: finish active recording session
        if let activeRecording,
           activeRecording.state == .recording,
           activeRecording.appointmentID == appointmentID {
            audioRecordingService.finish()
            return
        }

        audioRecordingService.start(appointmentID: appointmentID)
    }

    func pauseRecording() {
        audioRecordingService.pause()
    }

    func finishRecording() {
        audioRecordingService.finish()
    }

    func cancelRecording() {
        audioRecordingService.cancel()
    }

    /// Get recording state for a particular appointment
    func getRecordingState() -> ActiveRecordingState {
        guard let activeRecording,
              activeRecording.appointmentID == appointmentID else {
            return .scheduled
        }

        return activeRecording.state
    }

    /// Get color apropriate for a recording state of an appointment
    static func getColor(for recordingState: ActiveRecordingState) -> SwiftUI.Color {
        switch recordingState {
        case .scheduled:
            return .cyan
        case .recording:
            return .cyan
        case .paused:
            return .gray
        case .completed:
            return .cyan
        case .cancelled:
            return .red
        }
    }

    /// Color of microphone on page
    static func getMicrophoneImageSystemName(for recordingState: ActiveRecordingState) -> String {
        switch recordingState {
        case .scheduled:
            "mic.circle"
        case .recording:
            "mic.circle.fill"
        case .paused:
            "mic.circle"
        case .completed:
            "mic.circle"
        case .cancelled:
            "mic.slash.circle.fill"
        }
    }
}
