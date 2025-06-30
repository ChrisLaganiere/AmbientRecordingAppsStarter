import Combine

/**
 # AudioRecording
 Protocol for service which records audio and saves data to app cache
 */
@MainActor
protocol AudioRecording {

    /// Info about the current recording session status
    var activeRecording: ActiveRecording? { get }
    /// Publisher for info about the current recording session status
    var activeRecordingPublisher: AnyPublisher<ActiveRecording?, Never> { get }

    /// Start recording for appointment
    func start(appointmentID: Appointment.ID)
    /// Pause recording
    func pause()
    /// Cancel recording
    func cancel()
    /// Finish recording for appointment and save
    func finish()
}

// MARK: Definitions

/// Info for displaying current recording session status
struct ActiveRecording {
    let appointmentID: Appointment.ID
    let state: ActiveRecordingState

    init(
        appointmentID: Appointment.ID,
        state: ActiveRecordingState = .scheduled
    ) {
        self.appointmentID = appointmentID
        self.state = state
    }

    /// Update state
    func updatingState(to state: ActiveRecordingState) -> Self {
        ActiveRecording(
            appointmentID: appointmentID,
            state: state
        )
    }
}

/// Available status for active recording session
enum ActiveRecordingState: String {
    case scheduled
    case recording
    case paused
    case completed
    case cancelled

    /// Specifies if state is a terminal state for a particular recording session
    var isFinished: Bool {
        switch self {
        case .scheduled,
             .recording,
             .paused:
            return false
        case .completed,
             .cancelled:
            return true
        }
    }
}
