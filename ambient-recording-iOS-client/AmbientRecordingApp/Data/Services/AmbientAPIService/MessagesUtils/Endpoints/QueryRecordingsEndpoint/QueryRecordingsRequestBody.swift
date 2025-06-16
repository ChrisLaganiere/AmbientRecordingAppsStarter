import Foundation

/**
 # QueryRecordingsRequest
 Get recordings from server
 */
typealias QueryRecordingsRequest = JSONEndpointRequest<QueryRecordingsRequestBody, JSONEndpointResponse<QueryRecordingsResponseBody>>

// MARK: Default Configuration
extension QueryRecordingsRequest {
    /// Create a new request to send to server
    init(params: QueryRecordingsRequestParams) {
        self.init(
            method: .get,
            url: params.buildGetRequestURL()
        )
    }
}

/**
 # QueryRecordingsRequestBody
 Body of request to `/v1/recordings/query` endpoint
 */
struct QueryRecordingsRequestBody: Codable {
    // Empty body because this is a GET request
}
