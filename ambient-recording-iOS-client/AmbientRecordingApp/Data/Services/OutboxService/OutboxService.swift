import Foundation
import Combine

/**
 # OutboxService
 Service which publishes pending local changes
 */
@MainActor
final class OutboxService: OutboxServing {

    struct Dependencies {
        /// Service providing integration with Ambient server
        let ambientAPIService: any AmbientAPIServing
        /// App cache controller
        let persistenceController: any CoreDataPersisting
    }

    // MARK: Private Properties

    /// Required dependencies
    private let dependencies: Dependencies
    /// Combine publishers to retain until object is released
    private var cancellables: Set<AnyCancellable> = []
    /// Internal state flag to prevent misuse
    private var isMonitoringNetwork: Bool = false
    /// Task cache storing ongoing operations so we can avoid repeating work
    private let taskStore: TaskStore<OutboxItem, Void>
    /// Periodic timer polling for data
    private var timer: Timer?

    // MARK: Methods

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        // Set up task store with "await next result" behavior,
        // to avoid repeating the same publish requests already running.
        self.taskStore = .init(behavior: .awaitNextResult)
    }

    /// Enqueue publish for a new recording saved in cache
    func publishRecording(id: Recording.ID) async throws {
        try await Recording.addPublishIntention(
            recordingID: id,
            persistenceController: dependencies.persistenceController
        )
        await publishPendingItems()
    }

    /// Enqueue publish for a new appointment saved in cache
    func publishAppointment(id: Appointment.ID) async throws {
        try await Appointment.addPublishIntention(
            appointmentID: id,
            persistenceController: dependencies.persistenceController
        )
        await publishPendingItems()
    }

    /// Enqueue delete for a new appointment saved in cache
    func deleteAppointment(id: Appointment.ID) async throws {
        try await Appointment.addDeleteIntention(
            appointmentID: id,
            persistenceController: dependencies.persistenceController
        )
        await publishPendingItems()
    }

    /// Start monitoring network, and publish pending items as soon as network becomes available
    func publishPendingItemsWhenOnline(
        _ networkMonitoringService: any NetworkMonitoring
    ) {
        guard !isMonitoringNetwork else {
            // This method should only be called once per app session
            assertionFailure("Misuse of OutboxService")
            return
        }

        networkMonitoringService.isOnlinePublisher
            .sink { [weak self] isOnline in
                Task { [weak self] in
                    await self?.publishPendingItems()
                }
            }
            .store(in: &self.cancellables)

        // BOGUS: for demo purposes, I will be turning on and off the server
        // without touching the iOS device/simulator...
        // Normally we would see network monitor fire when device moves around,
        // but for this demo we can just have a timer triggering publishes
        // so that things show up more quickly.
        startPublishingOnTimer()

        isMonitoringNetwork = true
    }

    // MARK: Private Methods

    /// Start syncing app cache with server
    private func startPublishingOnTimer() {
        guard timer == nil else {
            return
        }

        // Set up a publish attempt every 10 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task { [weak self] in
                await self?.publishPendingItems()
            }
        }
    }

    /// Start publishing any local changes waiting to be saved
    private func publishPendingItems() async {
        let outboxItems: Set<OutboxItem> = await dependencies.persistenceController.performBackgroundTask { moc in

            var outboxItems: Set<OutboxItem> = []

            // 1. Check for pending appointments
            let appointments = try? Appointment.all(moc: moc)
            for appointment in appointments ?? [] {
                if appointment.pendingPublishIntention?.create == true {
                    outboxItems.insert(.createAppointment(appointment.id))
                }
            }

            // 2. Check for pending recordings
            let recordings = try? Recording.all(moc: moc)
            for recording in recordings ?? [] {
                if recording.pendingPublishIntention?.create == true,
                   recording.appointment?.hasSynced == true {
                    outboxItems.insert(.createRecording(recording.id))
                }
            }

            // TODO: support other actions like update, delete

            return outboxItems
        }
        
        // Start background tasks to publish enqueued work
        for item in outboxItems {
            await enqueueOutboxItem(item)
        }
    }

    /// Start task to finish an item
    private func enqueueOutboxItem(_ outboxItem: OutboxItem) async {
        await taskStore.enqueue(for: outboxItem) {
            switch outboxItem {

            case .createAppointment(let appointmentID):
                try await self.dependencies.ambientAPIService
                    .createAppointment(id: appointmentID)

            case .createRecording(let recordingID):
                try await self.dependencies.ambientAPIService
                    .createRecording(id: recordingID)

            }
        }
    }
}

/// Errors that can occur while publishing cached data
enum OutboxServiceError: Error {
    case entityNotFound
}

/// Long-running async actions performed by Outbox
enum OutboxItem: Hashable {
    case createAppointment(Appointment.ID)
    case createRecording(Recording.ID)
}
