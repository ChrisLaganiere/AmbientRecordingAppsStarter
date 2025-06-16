import Foundation

/**
 # NetworkSession
 Type erasure for `URLSession`
 */
public final class MockNetworkSession {

    /// Configurable option describing how mock network request should finish
    public var behavior: Behavior

    public init(behavior: Behavior = .succeed(.default)) {
        self.behavior = behavior
    }

    /// Retrieves the contents of a URL and delivers the data asynchronously.
    /// https://developer.apple.com/documentation/foundation/urlsession/3767353-data
    public func data(
        for request: URLRequest,
        delegate: (any URLSessionTaskDelegate)?
    ) async throws -> (Data, URLResponse) {
        switch behavior {

        case .fail(let error):
            throw error

        case .succeed(let response):
            return (response.data, response.urlResponse)
        }
    }
}

// MARK: Definitions
public extension MockNetworkSession {

    /// How `MockNetworkSession` can be configured to behave
    enum Behavior {
        case fail(Error)
        case succeed(MockResponse)
    }

    /// Possible responses from mock server
    struct MockResponse {
        /// Response body
        var data: Data
        /// Information about network response
        var urlResponse: URLResponse

        /// Easy-to-use mocked success response (with empty body)
        public static var `default`: Self {
            MockResponse(
                data: "".data(using: .utf8)!,
                urlResponse: URLResponse(
                    url: URL(string: "https://developer.apple.com/")!,
                    mimeType: nil,
                    expectedContentLength: 0,
                    textEncodingName: nil
                )
            )
        }
    }
}
