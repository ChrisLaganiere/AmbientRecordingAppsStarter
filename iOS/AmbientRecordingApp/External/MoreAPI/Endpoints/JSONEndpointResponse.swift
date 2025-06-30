import Foundation

/**
 # JSONEndpointResponse
 `APIEndpointResponse` implementation for an endpoint that takes and returns JSON values
 */
public struct JSONEndpointResponse<CodableResponse: Codable>: APIEndpointResponse {

    /// Response returned from server
    let value: CodableResponse

    /// Read information returned from server from a network request
    public static func decode(data: Data, response: URLResponse) throws -> Self {
        // 1. Decode from JSON
        let decoder = JSONDecoder()
        let value = try decoder.decode(CodableResponse.self, from: data)
        return Self(value: value)
    }
}
