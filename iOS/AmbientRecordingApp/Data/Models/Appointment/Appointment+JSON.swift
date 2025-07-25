import Foundation

/**
 # JSONAppointment
 Codable value for `Appointment` entity, for building server requests
 */
struct JSONAppointment: Codable {
    /// unique identifier for entity (generated by server)
    var id: String
    /// opaque version tag (generated by server)
    var etag: String?
    /// name of patient who is the focus of appointment
    var patientName: String?
    /// expected start time, ISO 8601 Date string
    var scheduledStart: String?
    /// expected end time, ISO 8601 Date string
    var scheduledEnd: String?
    /// any additional notes
    var notes: String?

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case id
        case etag
        case patientName = "patient_name"
        case scheduledStart = "scheduled_start"
        case scheduledEnd = "scheduled_end"
        case notes
    }
}

extension Appointment {
    /// Update with properties from JSON returned by server
    func configure(with json: JSONAppointment) throws {
        self.appointmentID = json.id
        self.etag = json.etag
        self.patientName = json.patientName
        self.scheduledStart = Date.fromISODate(json.scheduledStart)
        self.scheduledEnd = Date.fromISODate(json.scheduledEnd)
        self.notes = json.notes
    }

    /// Format JSON representing entity to send to server
    func toJSON() -> JSONAppointment {
        JSONAppointment(
            id: appointmentID,
            etag: etag,
            patientName: patientName,
            scheduledStart: scheduledStart?.ISO8601Format(),
            scheduledEnd: scheduledEnd?.ISO8601Format(),
            notes: notes
        )
    }
}
