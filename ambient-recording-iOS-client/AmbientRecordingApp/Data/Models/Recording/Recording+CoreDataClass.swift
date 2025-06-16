import Foundation
import CoreData

@objc(Recording)
public class Recording: NSManagedObject {

    /// This entity has been synced with server in the past
    var hasSynced: Bool {
        // Server generates this property
        etag != nil
    }

    /// Format start date for display in UI
    var formattedDate: String? {
        guard let start = start else {
            return nil
        }

        let formatted = start.formatted(date: .omitted, time: .shortened)
        return formatted
    }

    /// Create a new recording from audio recorder
    static func create(
        with json: JSONRecording,
        in persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in
            let recording = Recording(context: moc)
            try recording.configure(with: json)
            recording.setUpRelationships(json: json, moc: moc)
            try moc.save()
        }
    }

}

extension Recording : Identifiable {
    public var id: String {
        recordingID
    }
}
