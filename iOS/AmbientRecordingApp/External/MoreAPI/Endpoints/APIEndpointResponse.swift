import Foundation

/**
 # APIEndpointResponse
 Definition of available information from server response from an endpoint.
 */
public protocol APIEndpointResponse {
    /// Read information returned from server from a network request
    static func decode(data: Data, response: URLResponse) throws -> Self
}
