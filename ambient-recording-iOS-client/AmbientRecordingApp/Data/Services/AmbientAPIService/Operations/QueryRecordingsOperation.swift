import Foundation

/**
 # QueryRecordingsOperation
 Async operation which will fetch recordings from Ambient API,
 and save entities locally to app cache, to be used and displayed by features.
 */
actor QueryRecordingsOperation: TaskBasedOperation {

    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
        /// Controller managing app cache
        let persistenceController: any CoreDataPersisting
    }

    /// Appointment to fetch recordings for
    let appointmentID: Appointment.ID

    /// Required dependencies
    let dependencies: Dependencies

    /// Maximum number of items to fetch
    let fetchLimit: UInt

    // MARK: Private Properties

    /// Internal storage for `TaskBasedOperation` utility
    let internalTask = OperationTask<Void, Error>()

    /// Create a new single-use instance of operation to perform network request
    init(
        appointmentID: Appointment.ID,
        dependencies: Dependencies,
        fetchLimit: UInt = .max
    ) {
        self.appointmentID = appointmentID
        self.dependencies = dependencies
        self.fetchLimit = fetchLimit
    }

    /// Main body of operation
    func main() async throws {
        try await fetchRecordings()
    }

    /// Fetch all available recordings from API,
    /// crawling through all pages of `/v1/recordings/query` endpoint.
    private func fetchRecordings() async throws {
        var nextPage: Int? = nil
        var fetched: Set<Recording.ID> = []
        repeat {
            let response = try await fetchRecordings(from: nextPage)
            fetched.formUnion(response.items.map(\.id))
            nextPage = response.metadata?.nextPage
        } while nextPage != nil && fetched.count < fetchLimit

        // Delete stale personas, after fetching all of them
        try await deleteStaleRecordings(activeIDs: fetched)

        print("did fetch \(fetched.count) recordings")
    }

    /// Fetch one page of personas, starting from optional continuation link
    private func fetchRecordings(
        from page: Int? = nil
    ) async throws -> QueryRecordingsResponseBody {
        let response = try await FetchPageOfRecordingsOperation(
            dependencies: .init(
                apiService: dependencies.apiService
            ),
            params: .init(appointmentID: appointmentID)
        ).execute()

        try await response.save(to: dependencies.persistenceController)
        return response
    }

    /// Delete personas which were not returned from server during entire search from app cache
    private func deleteStaleRecordings(activeIDs: Set<Recording.ID>) async throws {
        try await dependencies.persistenceController.performBackgroundTask { moc in
            let all = try Recording.all(moc: moc)
            let staleIDs = all.mapToSet(\.id)
                .subtracting(activeIDs)
                .subtracting(all.filter({ $0.pendingItem != nil }).map(\.id))
            if staleIDs.isEmpty == false {
                try Recording.deleteAll(matching: .recordingIDs(staleIDs), moc: moc)
                try moc.save()
            }
        }
    }
}
