import Foundation

/**
 # RecordingPublishIntention
 Local cache info about what actions we intend to perform on an entity
 */
struct RecordingPublishIntention: Codable {
    var create = false
}

// MARK: Helpers
extension RecordingPublishIntention {
    /// Create a new appointment
    static let create = RecordingPublishIntention(create: true)
}

// MARK: PendingPublish
extension RecordingPublishIntention: PendingPublish {
    /// Add new publish intentions to existing
    func merge(_ other: Self) -> Self {
        RecordingPublishIntention(
            create: create || other.create
        )
    }
}

// MARK: CustomDebugStringConvertible
extension RecordingPublishIntention: CustomDebugStringConvertible {
    var debugDescription: String {
        create ? "create" : ""
    }
}
