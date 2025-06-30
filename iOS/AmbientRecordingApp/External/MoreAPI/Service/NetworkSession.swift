import Foundation

/**
 # NetworkSession
 Type erasure for `URLSession`
 */
public protocol NetworkSession {
    /// Retrieves the contents of a URL and delivers the data asynchronously.
    /// https://developer.apple.com/documentation/foundation/urlsession/3767353-data
    func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse)
}

// MARK: Helpers
extension NetworkSession {
    /// Retrieves the contents of a URL and delivers the data asynchronously.
    /// https://developer.apple.com/documentation/foundation/urlsession/3767353-data
    func data(
        for request: URLRequest
    ) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
