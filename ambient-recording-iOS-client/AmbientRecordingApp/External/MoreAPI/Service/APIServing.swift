import Foundation

/**
 # APIServing
 Protocol for service which communicates with our servers
 */
public protocol APIServing {
    /// Perform a network request with Codable values
    func fetch<Request: APIEndpointRequest>(
        _ request: Request
    ) async throws -> Request.Response

    /// Perform a network request
    func fetch(url: URL, body: Data?) async throws -> Data
}

// MARK: Helpers
extension APIServing {
    /// Perform a network request
    func fetch(url: URL) async throws -> Data {
        try await fetch(url: url, body: nil)
    }
}
