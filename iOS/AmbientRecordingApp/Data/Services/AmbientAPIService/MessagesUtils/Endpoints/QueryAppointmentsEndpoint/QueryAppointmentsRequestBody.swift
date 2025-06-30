import Foundation

/**
 # QueryAppointmentsRequest
 Get appointments from server
 */
typealias QueryAppointmentsRequest = JSONEndpointRequest<QueryAppointmentsRequestBody, JSONEndpointResponse<QueryAppointmentsResponseBody>>

// MARK: Default Configuration
extension QueryAppointmentsRequest {
    /// Create a new request to send to server
    init() {
        self.init(
            method: .get,
            url: AmbientEndpoints.queryAppointments.url
        )
    }
}

/**
 # QueryAppointmentsRequestBody
 Body of request to `/v1/appointments/query` endpoint
 */
struct QueryAppointmentsRequestBody: Codable {
    // Empty body because this is a GET request
}
