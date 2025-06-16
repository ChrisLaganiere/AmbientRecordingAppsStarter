import Foundation

/**
 # CreateRecordingRequest
 Publish a new recording to server
 */
typealias CreateRecordingRequest = JSONEndpointRequest<CreateRecordingRequestBody, JSONEndpointResponse<CreateRecordingResponseBody>>

// MARK: Default Configuration
extension CreateRecordingRequest {
    /// Create a new request to send to server
    init(body: CreateRecordingRequestBody) {
        self.init(
            method: .post,
            url: AmbientEndpoints.createRecording.url,
            body: body
        )
    }
}

/**
 # CreateRecordingRequestBody
 Body of request to `/v1/recordings/create` endpoint
 */
struct CreateRecordingRequestBody: Codable {
    var clientID: String
    var item: JSONRecording

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case item
    }
}
