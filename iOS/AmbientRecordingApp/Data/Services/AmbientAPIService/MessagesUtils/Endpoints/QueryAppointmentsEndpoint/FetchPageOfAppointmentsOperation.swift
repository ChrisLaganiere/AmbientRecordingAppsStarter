import Foundation

/**
 # FetchPageOfAppointmentsOperation
 Async operation which will fetch one page of appointments from Ambient API.

 TODO: in the future, this could have query params added for better querying,
 as detailed in the API contract. Instead, it now fetches all appointments as a shortcut.
 */
actor FetchPageOfAppointmentsOperation: TaskBasedOperation {

    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
    }

    /// Required dependencies
    let dependencies: Dependencies

    // MARK: Private Properties

    /// Internal storage for `TaskBasedOperation` utility
    let internalTask = OperationTask<QueryAppointmentsResponseBody, Error>()

    /// Create a new single-use instance of operation to perform network request
    init(
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
    }

    /// Main body of operation
    func main() async throws -> QueryAppointmentsResponseBody {
        let request = QueryAppointmentsRequest()
        let endpoint = AmbientEndpoints.queryAppointments
        print("Sending request to \(endpoint.path)")
        let response = try await dependencies.apiService
            .fetch(request)
            .value
        return response
    }
}

