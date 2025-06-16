import Foundation

/**
 # FetchPageOfRecordingsOperation
 Async operation which will fetch one page of recordings from Ambient API.
 */
actor FetchPageOfRecordingsOperation: TaskBasedOperation {

    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
    }

    /// Required dependencies
    let dependencies: Dependencies

    /// Detais about which recordings to fetch for
    let params: QueryRecordingsRequestParams

    // MARK: Private Properties

    /// Internal storage for `TaskBasedOperation` utility
    let internalTask = OperationTask<QueryRecordingsResponseBody, Error>()

    /// Create a new single-use instance of operation to perform network request
    init(
        dependencies: Dependencies,
        params: QueryRecordingsRequestParams
    ) {
        self.dependencies = dependencies
        self.params = params
    }

    /// Main body of operation
    func main() async throws -> QueryRecordingsResponseBody {
        let request = QueryRecordingsRequest(params: params)

        print("Sending request to \(request.url.path())")
        let response = try await dependencies.apiService
            .fetch(request)
            .value
        return response
    }
}

