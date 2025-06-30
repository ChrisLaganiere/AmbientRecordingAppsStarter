import Foundation

/**
 # APIEndpointRequest
 Definition of configurable information in server request to an endpoint.
 */
public protocol APIEndpointRequest {
    associatedtype Response: APIEndpointResponse

    /// Build a `URLRequest` to send to server endpoint
    func encode() throws -> URLRequest
}
