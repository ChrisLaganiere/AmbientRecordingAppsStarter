import Foundation

/**
 # CreateAppointmentRequest
 Publish a new appointment to server
 */
typealias CreateAppointmentRequest = JSONEndpointRequest<CreateAppointmentRequestBody, JSONEndpointResponse<CreateAppointmentResponseBody>>

// MARK: Default Configuration
extension CreateAppointmentRequest {
    /// Create a new request to send to server
    init(body: CreateAppointmentRequestBody) {
        self.init(
            method: .post,
            url: AmbientEndpoints.createAppointment.url,
            body: body
        )
    }
}

/**
 # CreateAppointmentRequestBody
 Body of request to `/v1/appointments/create` endpoint
 */
struct CreateAppointmentRequestBody: Codable {
    var clientID: String
    var item: JSONAppointment

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case item
    }
}
