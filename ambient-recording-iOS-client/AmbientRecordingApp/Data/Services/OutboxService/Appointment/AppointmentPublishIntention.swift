import Foundation

/**
 # AppointmentPublishIntention
 Local cache info about what actions we intend to perform on an entity
 */
struct AppointmentPublishIntention: Codable {
    var create = false
    var update = false
    var delete = false
}

// MARK: Helpers
extension AppointmentPublishIntention {
    /// Create a new appointment
    static let create = AppointmentPublishIntention(create: true)
    /// Update an existing appointment
    static let update = AppointmentPublishIntention(update: true)
    /// Delete an appointment
    static let delete = AppointmentPublishIntention(delete: true)
}

// MARK: PendingPublish
extension AppointmentPublishIntention: PendingPublish {
    /// Add new publish intentions to existing
    func merge(_ other: Self) -> Self {
        AppointmentPublishIntention(
            create: create || other.create,
            update: update || other.update,
            delete: delete || other.delete
        )
    }
}

// MARK: CustomDebugStringConvertible
extension AppointmentPublishIntention: CustomDebugStringConvertible {
    var debugDescription: String {
        [
            create ? "create" : nil,
            update ? "update" : nil,
            delete ? "delete" : nil
        ]
            .compactMap { $0 }
            .joined(separator: ", ")
    }
}
