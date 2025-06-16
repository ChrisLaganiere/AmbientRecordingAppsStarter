import CoreData

/**
 # CreateRecordingResponseBody
 Body of response from `/v1/recordings/create` endpoint
 */
struct CreateRecordingResponseBody: Codable {

    var clientID: String
    var item: JSONRecording?
    var status: AmbientAPIStatusObject

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case item
        case status
    }
}

// MARK: Helpers
extension CreateRecordingResponseBody {

    /// Convert JSON into Core Data entities, and save them
    @discardableResult
    func save(in moc: NSManagedObjectContext) -> Recording? {
        guard let item else {
            return nil
        }

        // Find entity in app cache that matches this record, either:
        // - with the same id, if already synced with server
        // - with the same client_id, if server just received a new recording and generated an identifier
        // - totally new, created on a different device
        let recording: Recording = (try? Recording.entity(
            matching: .recordingID(item.id),
            moc: moc
        )) ?? (try? Recording.entity(
            matching: .recordingID(clientID),
            moc: moc
        )) ?? Recording(context: moc)

        do {
            try recording.configure(with: item)
            recording.setUpRelationships(json: item, moc: moc)
            return recording
        }
        catch {
            print("failed to configure recording: \(error)")
            return nil
        }
    }

    /// Convert JSON into Core Data entities, and save them
    static func save(
        _ response: Self,
        to persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in

            // 1. Add/update new item
            response.save(in: moc)

            // 2. Save
            try moc.save()

        }
    }
}
