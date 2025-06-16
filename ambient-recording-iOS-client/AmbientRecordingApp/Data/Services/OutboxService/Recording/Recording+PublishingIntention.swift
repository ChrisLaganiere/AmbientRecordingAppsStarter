import Foundation

extension Recording: PublishingIntention {
    typealias PublishIntention = RecordingPublishIntention

    /// Add local flag expressing intention for entity to be created on server
    static func addPublishIntention(
        recordingID: Recording.ID,
        persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in

            // 1. Look up entity in cache
            guard let recording = try Recording.entity(
                matching: .recordingID(recordingID),
                moc: moc
            ) else {
                throw OutboxServiceError.entityNotFound
            }

            // 2. Mark as needing publish at next opportunity
            recording.savePublishIntention(.create, moc: moc)

            try moc.save()
        }
    }
}
