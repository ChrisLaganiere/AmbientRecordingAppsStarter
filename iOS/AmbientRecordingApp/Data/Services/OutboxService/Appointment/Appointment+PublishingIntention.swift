import CoreData

extension Appointment: PublishingIntention {
    typealias PublishIntention = AppointmentPublishIntention

    /// Add local flag expressing intention for entity to be created on server
    static func addPublishIntention(
        appointmentID: Appointment.ID,
        persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in

            // 1. Look up entity in cache
            guard let appointment = try Appointment.entity(
                matching: .appointmentID(appointmentID),
                moc: moc
            ) else {
                throw OutboxServiceError.entityNotFound
            }

            // 2. Mark as needing publish at next opportunity
            appointment.savePublishIntention(
                appointment.hasSynced ? .update : .create,
                moc: moc
            )

            try moc.save()
        }
    }

    /// Add local flag expressing intention for entity to be deleted on server
    static func addDeleteIntention(
        appointmentID: Appointment.ID,
        persistenceController: any CoreDataPersisting
    ) async throws {
        try await persistenceController.performBackgroundTask { moc in

            // 1. Look up entity in cache
            guard let appointment = try Appointment.entity(
                matching: .appointmentID(appointmentID),
                moc: moc
            ) else {
                throw OutboxServiceError.entityNotFound
            }

            // 2. Mark as needing delete at next opportunity
            appointment.savePublishIntention(.delete, moc: moc)

            try moc.save()
        }
    }
}
