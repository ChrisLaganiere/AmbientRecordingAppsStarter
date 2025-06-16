import Foundation

/**
 # QueryAppointmentsResponseBody
 Body of response from `/v1/appointments/query` endpoint
 */
struct QueryAppointmentsResponseBody: Codable {

    /// Items returned in response
    let items: [JSONAppointment]

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
extension QueryAppointmentsResponseBody {

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
            let allAppointment = try Appointment.all(moc: moc)

            // 1. Add/update new items
            for item in response.items {
                let appointment = allAppointment.first(where: { $0.id == item.id })
                    ?? Appointment(context: moc)
                do {
                    try appointment.configure(with: item)
                    appointment.setUpRelationships(json: item, moc: moc)
                }
                catch {
                    print("failed to configure appointment: \(error)")
                }
            }

            // 2. Save
            try moc.save()
        }
    }
}
