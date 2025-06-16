import Foundation

/**
 # QueryAppointmentsOperation
 Async operation which will fetch appointments from Ambient API,
 and save entities locally to app cache, to be used and displayed by features.
 */
actor QueryAppointmentsOperation: TaskBasedOperation {

    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
        /// Controller managing app cache
        let persistenceController: any CoreDataPersisting
    }

    /// Required dependencies
    let dependencies: Dependencies

    /// Maximum number of items to fetch
    let fetchLimit: UInt

    // MARK: Private Properties

    /// Internal storage for `TaskBasedOperation` utility
    let internalTask = OperationTask<Void, Error>()

    /// Create a new single-use instance of operation to perform network request
    init(
        dependencies: Dependencies,
        fetchLimit: UInt = .max
    ) {
        self.dependencies = dependencies
        self.fetchLimit = fetchLimit
    }

    /// Main body of operation
    func main() async throws {
        try await fetchAllAppointments()
    }

    /// Fetch all available appointments from API,
    /// crawling through all pages of `/v1/appointments/query` endpoint.
    private func fetchAllAppointments() async throws {
        var nextPage: Int? = nil
        var fetched: Set<Appointment.ID> = []
        repeat {
            let response = try await fetchAppointments(from: nextPage)
            fetched.formUnion(response.items.map(\.id))
            nextPage = response.metadata?.nextPage
        } while nextPage != nil && fetched.count < fetchLimit

        // Delete stale personas, after fetching all of them
        try await deleteStaleAppointments(activeIDs: fetched)

        print("did fetch \(fetched.count) appointments")
    }

    /// Fetch one page of personas, starting from optional continuation link
    private func fetchAppointments(
        from page: Int? = nil
    ) async throws -> QueryAppointmentsResponseBody {
        let response = try await FetchPageOfAppointmentsOperation(
            dependencies: .init(
                apiService: dependencies.apiService
            )
        ).execute()

        try await response.save(to: dependencies.persistenceController)
        return response
    }

    /// Delete personas which were not returned from server during entire search from app cache
    private func deleteStaleAppointments(activeIDs: Set<Appointment.ID>) async throws {
        try await dependencies.persistenceController.performBackgroundTask { moc in
            let all = try Appointment.all(moc: moc)
            let staleIDs = all.mapToSet(\.id)
                .subtracting(activeIDs)
                .subtracting(all.filter({ $0.pendingItem != nil }).map(\.id))
            if staleIDs.isEmpty == false {
                try Appointment.deleteAll(matching: .appointmentIDs(staleIDs), moc: moc)
                try moc.save()
            }
        }
    }
}
