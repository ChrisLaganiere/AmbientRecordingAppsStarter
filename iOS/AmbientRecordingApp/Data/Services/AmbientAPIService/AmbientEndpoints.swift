import Foundation

/**
 # AmbientEndpoints
 Available endpoints to send requests to, and associated URLs.

 ### Idea:
 Instead of hardcoding all our endpoint URLs, we could instead fetch the URLs from server as part
 of a "bootstrap" on app launch. This can be useful for migrating clients to new API versions, or new hosts.
 */
enum AmbientEndpoints {

    /// BOGUS: hard-coded for now. This could be supplied from a service in order
    /// to integrate with different server environments.
    static let domain = "http://localhost:8000"

    /// Create a new appointment entity.
    case createAppointment

    /// Fetch appointments from server.
    case queryAppointments

    /// Create a new recording entity.
    case createRecording

    /// Fetch recordings from server.
    case queryRecordings

    /// Path portion of web link for endpoint
    var path: String {
        let path: String

        switch self {
        case .createAppointment:
            path = "/v1/appointments/create"
        case .queryAppointments:
            path = "/v1/appointments/query"
        case .createRecording:
            path = "/v1/recordings/create"
        case .queryRecordings:
            path = "/v1/recordings/query"
        }

        return path
    }
    /// Web link for endpoint
    var url: URL {
        URL(string: "\(Self.domain)\(path)")!
    }
}
