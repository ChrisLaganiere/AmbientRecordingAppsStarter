import Foundation

/// Filters which specify particular entities to fetch
public enum RecordingFilter: Filtering {
    /// All entities (no predicate)
    case all
    /// Unique identifier
    case recordingID(Recording.ID)
    /// Unique identifier(s)
    case recordingIDs(Set<Recording.ID>)
    /// Unique identifier
    case appointmentID(Appointment.ID)
    /// Unique identifier(s)
    case appointmentIDs(Set<Appointment.ID>)

    public var predicate: NSPredicate? {
        switch self {

        case .all:
            return nil

        case .recordingID(let recordingID):
            return NSPredicate(format: "recordingID == %@", recordingID)

        case .recordingIDs(let recordingIDs):
            return NSPredicate(format: "recordingID IN %@", recordingIDs)

        case .appointmentID(let appointmentID):
            return NSPredicate(format: "appointmentID == %@", appointmentID)

        case .appointmentIDs(let appointmentIDs):
            return NSPredicate(format: "appointmentID IN %@", appointmentIDs)
        }
    }
}

/// Sort descriptors which specify how to sort fetched results
public enum RecordingSort: Sorting {
    /// Sort by start time
    case start

    public var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .start:
            [
                NSSortDescriptor(keyPath: \Recording.start, ascending: true),
                // Fall back to unique ID to ensure consistent sort order
                NSSortDescriptor(keyPath: \Recording.recordingID, ascending: true)
            ]
        }
    }
}

// MARK: Fetchable
extension Recording: Fetchable {
    public typealias Filter = RecordingFilter
    public typealias Sort = RecordingSort

    public static var entityName: String {
        "Recording"
    }
}
