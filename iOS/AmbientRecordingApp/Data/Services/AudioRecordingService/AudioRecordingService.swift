import Combine
import CoreData

/**
 # AudioRecording
 Service which records audio and saves data to app cache
 */
@MainActor
final class AudioRecordingService: AudioRecording {

    struct Dependencies {
        /// Service responsible for publishing entities to server
        let outboxService: any OutboxServing
        /// Controller managing app cache
        let persistenceController: any CoreDataPersisting
    }

    /// Info about the current recording session status
    @Published
    private(set) var activeRecording: ActiveRecording?
    /// Publisher for info about the current recording session status
    var activeRecordingPublisher: AnyPublisher<ActiveRecording?, Never> {
        $activeRecording.eraseToAnyPublisher()
    }

    // MARK: Private Properties

    /// Required dependencies
    private let dependencies: Dependencies

    /// Time when current recording started
    private var activeRecordingStartTime: Date?

    // MARK: Methods

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    /// Start recording for appointment
    func start(appointmentID: Appointment.ID) {
        // Resume recording
        if let activeRecording {
            // End recording previous appointment before starting a new one
            if activeRecording.appointmentID != appointmentID {
                self.finish()
            }
            // Resume recording
            else if !activeRecording.state.isFinished {
                self.activeRecording = activeRecording.updatingState(to: .recording)
                return
            }
        }

        activeRecording = ActiveRecording(appointmentID: appointmentID, state: .recording)
        activeRecordingStartTime = .now
    }

    /// Pause recording
    func pause() {
        guard let activeRecording, activeRecording.state == .recording else {
            return
        }

        self.activeRecording = activeRecording.updatingState(to: .paused)
    }

    /// Cancel recording
    func cancel() {
        guard let activeRecording else {
            return
        }

        self.activeRecording = activeRecording.updatingState(to: .cancelled)
        self.activeRecordingStartTime = nil
    }

    /// Finish recording for appointment and save
    func finish() {
        guard let activeRecording,
              !activeRecording.state.isFinished,
              let start = activeRecordingStartTime else {
            return
        }

        let end: Date = .now

        // BOGUS: for a real audio application, we would export a file here,
        // and save the bytes locally for upload. While processing the file,
        // we could determine a proper duration. For now, just imitate it!
        let duration = end.timeIntervalSince(start)

        self.activeRecording = activeRecording.updatingState(to: .completed)
        self.activeRecordingStartTime = nil

        // Save new audio recording to cache! (TODO =))
        // And then enqueue a publish to server
        Task {
            do {
                let recordingID = UUID().uuidString
                try await Recording.create(
                    with: .init(
                        id: recordingID,
                        appointmentID: activeRecording.appointmentID,
                        start: start.ISO8601Format(),
                        end: end.ISO8601Format(),
                        duration: duration
                    ),
                    in: self.dependencies.persistenceController
                )
                try await dependencies.outboxService.publishRecording(id: recordingID)
            }
            catch {
                print("failed to save audio recording: \(error)")
            }
        }
    }

}
