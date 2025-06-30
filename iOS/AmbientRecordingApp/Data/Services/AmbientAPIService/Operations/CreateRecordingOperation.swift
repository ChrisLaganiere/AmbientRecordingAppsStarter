import Foundation

/**
 # CreateRecordingOperation
 Async operation which will fetch appointments from Ambient API,
 and save entities locally to app cache, to be used and displayed by features.
 */
actor CreateRecordingOperation: TaskBasedOperation {

    struct Dependencies {
        /// Service to send network requests
        let apiService: any APIServing
        /// Controller managing app cache
        let persistenceController: any CoreDataPersisting
    }

    /// Recording in app cache to publish
    let recordingID: Recording.ID

    // MARK: Private Properties

    /// Required dependencies
    private let dependencies: Dependencies

    /// Save local app cache flag so we know if it's safe to clear out customer publish intention after success
    private var initialIntentionEtag: String?

    /// Internal storage for `TaskBasedOperation` utility
    let internalTask = OperationTask<Void, Error>()

    /// Create a new single-use instance of operation to perform network request
    init(
        recordingID: Recording.ID,
        dependencies: Dependencies
    ) {
        self.recordingID = recordingID
        self.dependencies = dependencies
    }

    /// Main body of operation
    func main() async throws {
        self.initialIntentionEtag = try await fetchIntentionEtag()
        
        // 1. Format request body
        guard let request = await formatRequest() else {
            return
        }
        
        do {
            // 2. Connect with server
            let response = try await publish(request)
            
            // 3. Process server response
            try await handleResponse(response)
        }
        catch {
            print("create appointment error: \(error)")
            throw error
        }
    }

    /// Find pending user intention in cache and format body for a network request
    private func formatRequest() async -> CreateRecordingRequest? {
        await dependencies.persistenceController.performBackgroundTask { moc in
            guard let recording = try? Recording.entity(
                matching: .recordingID(self.recordingID),
                moc: moc
            ) else {
                return nil
            }

            // Format request body
            return CreateRecordingRequest(
                body: .init(
                    clientID: recording.id,
                    item: recording.toJSON()
                )
            )
        }
    }

    /// Perform network request to server
    private func publish(
        _ request: CreateRecordingRequest
    ) async throws -> CreateRecordingResponseBody {
        print("Sending request to \(request.url.path())")
        let response = try await dependencies.apiService
            .fetch(request)
            .value
        return response
    }

    /// Update app cache with latest from server
    private func handleResponse(
        _ response: CreateRecordingResponseBody
    ) async throws {
        try await dependencies.persistenceController.performBackgroundTask { moc in

            // 1. Update cache with updated entity
            let recording = response.save(in: moc)

            // 2. Handle success by clearing intention
            if response.status.statusCode == .success, let recording {
                // Prevent race condition: what happens if new intention is saved
                // while the network request is in motion? This prevents that.
                // If the intention is not the same one we started with,
                // then we have no right to clear it!
                if recording.pendingItem?.etag == self.initialIntentionEtag {
                    recording.clearPublishIntention(moc: moc)
                }
            }

            // 3. Handle errors
            else {
                // TODO: we could handle by retrying, backing off, etc.
                // For simple demo, just leave intention so that publish may work later
            }

            try moc.save()
        }
    }

    /// Fetch local app cache flag so we know if it's safe to clear out customer publish intention after success
    private func fetchIntentionEtag() async throws -> String? {
        // Enhancement idea: `Fetchable` util could have methods
        // to make a simple property fetch like this easier.
        await dependencies.persistenceController.performBackgroundTask { moc in
            try? Recording.entity(
                matching: .recordingID(self.recordingID),
                moc: moc
            )?.pendingItem?.etag
        }
    }
}
