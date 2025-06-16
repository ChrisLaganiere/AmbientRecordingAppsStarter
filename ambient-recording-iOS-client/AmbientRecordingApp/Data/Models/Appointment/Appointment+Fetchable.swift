import Foundation

/// Filters which specify particular entities to fetch
public enum AppointmentFilter: Filtering {
    /// All entities (no predicate)
    case all
    /// Unique identifier
    case appointmentID(Appointment.ID)
    /// Unique identifier(s)
    case appointmentIDs(Set<Appointment.ID>)

    public var predicate: NSPredicate? {
        switch self {
            
        case .all:
            return nil

        case .appointmentID(let appointmentID):
            return NSPredicate(format: "appointmentID == %@", appointmentID)

        case .appointmentIDs(let appointmentIDs):
            return NSPredicate(format: "appointmentID IN %@", appointmentIDs)
        }
    }
}

/// Sort descriptors which specify how to sort fetched results
public enum AppointmentSort: Sorting {
    /// Sort by expected start time
    case start

    public var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .start:
            [
                NSSortDescriptor(keyPath: \Appointment.scheduledStart, ascending: true),
                NSSortDescriptor(keyPath: \Appointment.patientName, ascending: true),
                // Fall back to unique ID to ensure consistent sort order
                NSSortDescriptor(keyPath: \Appointment.appointmentID, ascending: true)
            ]
        }
    }
}

// MARK: Fetchable
extension Appointment: Fetchable {
    public typealias Filter = AppointmentFilter
    public typealias Sort = AppointmentSort

    public static var entityName: String {
        "Appointment"
    }
}
