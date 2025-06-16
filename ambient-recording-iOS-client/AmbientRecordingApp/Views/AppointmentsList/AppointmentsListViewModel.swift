import CoreData
import SwiftUI

/**
 # AppointmentsListViewModel
 View model for list showing recent and upcoming appointments.
 */
@MainActor
final class AppointmentsListViewModel: ObservableObject {

    /// Info about the current recording session status
    @Published
    private(set) var activeRecording: ActiveRecording?

    /// Publisher for appointment entities
    @Published private(set) var appointments: [Appointment] = []

    // MARK: Private Properties

    /// Controller fetching for appointment entities, and publishing updates as they are saved to the app cache
    private let appointmentsPublisher: FetchableResultsPublisher<Appointment>

    init(
        moc: NSManagedObjectContext,
        audioRecordingService: any AudioRecording
    ) {
        self.appointmentsPublisher = FetchableResultsPublisher(
            // We could add filters here to determine what to show in view!
            // Maybe all appointments is too much? We could filter for only
            // appointments from yesterday, today, and tomorrow maybe, like this:
//            filter: .all([
//                .start(.yesterdayMorning),
//                .end(.tomorrowNight)
//            ])
            sort: .start,
            moc: moc
        )

        // Assign fetched results to view model property
        try? appointmentsPublisher.beginFetch()
        appointmentsPublisher.fetchedObjectsPublisher.assign(to: &$appointments)

        // Assign recording session status to view model property
        audioRecordingService.activeRecordingPublisher.assign(to: &$activeRecording)
    }

    /// Get recording state for a particular appointment
    func getRecordingState(for appointmentID: Appointment.ID) -> ActiveRecordingState {
        guard let activeRecording,
              activeRecording.appointmentID == appointmentID else {
            return .scheduled
        }

        return activeRecording.state
    }
}
