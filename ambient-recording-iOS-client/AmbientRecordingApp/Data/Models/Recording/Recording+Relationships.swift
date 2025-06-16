import CoreData

extension Recording {
    /// Establish relationships for entity
    func setUpRelationships(
        json: JSONRecording,
        moc: NSManagedObjectContext
    ) {
        self.appointment = try? Appointment.entity(
            matching: .appointmentID(appointmentID),
            moc: moc
        )
    }
}
