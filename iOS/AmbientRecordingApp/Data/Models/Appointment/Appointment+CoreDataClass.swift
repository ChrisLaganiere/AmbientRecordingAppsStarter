import Foundation
import CoreData

@objc(Appointment)
public class Appointment: NSManagedObject {

    /// This entity has been synced with server in the past
    var hasSynced: Bool {
        // Server generates this property
        etag != nil
    }

    /// Format start date for display in UI
    var formattedDate: String? {
        guard let start = scheduledStart else {
            return nil
        }

        let formatted = start.formatted(date: .omitted, time: .shortened)
        return formatted
    }

    /// Create a new recording from audio recorder
    static func create(
        with json: JSONAppointment,
        in persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in
            let appointment = Appointment(context: moc)
            try appointment.configure(with: json)
            try moc.save()
        }
    }

    /// DEMO: Create a new appointment
    static func publishRandomAppointment(
        in persistenceController: any CoreDataPersisting,
        outbox: any OutboxServing
    ) {
        let name = [
            "Abigail A",
            "Carlos C",
            "Jash J",
            "Kelsey K",
            "Lawrence L",
            "Mike M",
            "Nancy N",
            "Onar O",
            "Pooja P",
        ].randomElement()

        let note = [
            "Rescheduled from last week",
            "Scheduled by referral",
            "New patient",
            "Special attention",
            "Second time this week",
            "Exceptional case"
        ].randomElement()

        // Schedule 15-minute appointments
        let startTime = Date.now.round(
            precision: 15 * 60,
            rule: .toNearestOrAwayFromZero
        )
        let endTime = startTime.addingTimeInterval(15 * 60)

        Task {
            do {
                let appointmentID = UUID().uuidString
                try await create(
                    with: .init(
                        id: appointmentID,
                        patientName: name,
                        scheduledStart: startTime.ISO8601Format(),
                        scheduledEnd: endTime.ISO8601Format(),
                        notes: note
                    ),
                    in: persistenceController
                )
                try await outbox.publishAppointment(id: appointmentID)
            }
            catch {
                print("failed to publish demo appointment: \(error)")
            }
        }
    }
}

extension Appointment : Identifiable {
    public var id: String {
        appointmentID
    }
}
