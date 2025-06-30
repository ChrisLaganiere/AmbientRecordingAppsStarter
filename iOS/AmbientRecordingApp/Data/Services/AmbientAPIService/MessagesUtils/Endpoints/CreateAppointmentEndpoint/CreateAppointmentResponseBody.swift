import CoreData

/**
 # CreateAppointmentResponseBody
 Body of response from `/v1/appointments/create` endpoint
 */
struct CreateAppointmentResponseBody: Codable {

    var clientID: String
    var item: JSONAppointment?
    var status: AmbientAPIStatusObject

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case item
        case status
    }
}

// MARK: Helpers
extension CreateAppointmentResponseBody {

    /// Convert JSON into Core Data entities, and save them
    @discardableResult
    func save(in moc: NSManagedObjectContext) -> Appointment? {
        guard let item else {
            return nil
        }

        // Find entity in app cache that matches this record, either:
        // - with the same id, if already synced with server
        // - with the same client_id, if server just received a new appointment and generated an identifier
        // - totally new, created on a different device
        let appointment: Appointment = (try? Appointment.entity(
            matching: .appointmentID(item.id),
            moc: moc
        )) ?? (try? Appointment.entity(
            matching: .appointmentID(clientID),
            moc: moc
        )) ?? Appointment(context: moc)

        do {
            try appointment.configure(with: item)
            appointment.setUpRelationships(json: item, moc: moc)
            return appointment
        }
        catch {
            print("failed to configure appointment: \(error)")
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
