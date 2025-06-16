import Foundation

/**
 # Refreshing
 Service which keeps local cache up-to-date with server, syncing data bi-directionally
 */
@MainActor
final class RefreshService: Refreshing {

    struct Dependencies {
        let ambientAPIService: any AmbientAPIServing
    }

    // MARK: Private Properties

    /// Required dependencies for service
    private let dependencies: Dependencies
    /// Cache for ongoing tasks, de-duped by string key
    private let taskStore: TaskStore<String, Void>
    /// Periodic timer polling for data
    private var timer: Timer?

    // MARK: Methods

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        // In order to avoid stacking up pending operations
        // before they can complete, we can de-dupe refreshes by key.
        self.taskStore = .init(behavior: .awaitNextResult)
    }

    /// Refresh all appointments right away
    func refreshAll() async {
        await withTaskGroup(of: Void.self, returning: Void.self) { [weak self] group in

            group.addTask { [weak self] in
                do {
                    try await self?.dependencies.ambientAPIService.refreshAppointments()
                }
                catch {
                    print("failed to refresh appointments: \(error)")
                }
            }

            // Could add more entities here if we wanted to poll more things!

            await group.waitForAll()
        }
    }

    /// Start syncing app cache with server
    func startRefreshing() {
        guard timer == nil else {
            return
        }

        // Set up polling every 5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            Task { [weak self] in

                // This task starts when polling timer fires.
                // There is an opportunity here to refresh any data we expect to show
                // in UI, for example recent and upcoming appointments for the home page.
                // By polling and refreshing in the background, we ensure that this data
                // is always kept up-to-date!
                print("\nPolling!")

                await self?.refreshAll()
            }
        }
    }

    /// Stop syncing app cache with server
    func stopRefreshing() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: Private Methods

    /// Immediately refresh list of appointments to show in UI
    private func refreshAppointments() async throws {
        let key = "Appointments"

        // The TaskStore automatically de-dupes requests by key, so that we
        // only send fetch requests one-at-a-time.
        let task = await taskStore.enqueue(for: key) { [weak self] in
            try await self?.dependencies.ambientAPIService.refreshAppointments()
        }

        return try await task.value
    }
}
