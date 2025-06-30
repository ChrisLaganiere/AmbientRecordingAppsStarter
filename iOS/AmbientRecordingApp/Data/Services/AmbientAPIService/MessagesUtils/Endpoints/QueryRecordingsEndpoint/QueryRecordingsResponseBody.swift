import Foundation

/**
 # QueryRecordingsResponseBody
 Body of response from `/v1/recordings/query` endpoint
 */
struct QueryRecordingsResponseBody: Codable {

    /// Items returned in response
    let items: [JSONRecording]

    /// Information about paginated query
    let metadata: AmbientPaginationMetadata?

    /// Request status
    let status: AmbientAPIStatusObject

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case items
        case metadata = "meta"
        case status
    }
}

// MARK: Helpers
extension QueryRecordingsResponseBody {

    /// Convert JSON into Core Data entities, and save them
    func save(to persistenceController: any CoreDataPersisting) async throws {
        try await Self.save(self, to: persistenceController)
    }

    /// Convert JSON into Core Data entities, and save them
    static func save(
        _ response: Self,
        to persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in
            let allRecording = try Recording.all(moc: moc)

            // 1. Add/update new items
            for item in response.items {
                let recording = allRecording.first(where: { $0.id == item.id })
                    ?? Recording(context: moc)
                do {
                    try recording.configure(with: item)
                    recording.setUpRelationships(json: item, moc: moc)
                }
                catch {
                    print("failed to configure recording: \(error)")
                }
            }

            // 2. Save
            try moc.save()
        }
    }
}
