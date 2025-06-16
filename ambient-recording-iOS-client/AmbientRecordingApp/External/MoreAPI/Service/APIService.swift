import Foundation

/**
 # APIService
 Service which performs network requests for you, in a type-safe way with registered `APIEndpoint` types.
 */
public actor APIService: APIServing {

    // MARK: Properties

    /// Factory which can build URL/network sessions
    private let networkSessionBuilder: NetworkSessionBuilding

    // MARK: Methods

    init(networkSessionBuilder: NetworkSessionBuilding = DefaultNetworkSessionBuilder()) {
        self.networkSessionBuilder = networkSessionBuilder
    }

    /// Perform a network request with Codable values
    public func fetch<Request: APIEndpointRequest>(
        _ request: Request
    ) async throws -> Request.Response {
        let session = networkSessionBuilder.newSession()
        let (data, urlResponse) = try await session.data(for: request.encode())
        let response = try Request.Response.decode(data: data, response: urlResponse)
        return response
    }

    /// Perform a network request
    public func fetch(url: URL, body: Data?) async throws -> Data {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.description
        urlRequest.httpBody = body
        let session = networkSessionBuilder.newSession()
        let (data, _) = try await session.data(for: urlRequest)
        return data
    }
}

public extension APIService {
    enum APIServiceError: Error, CustomDebugStringConvertible {
        /// Something went wrong
        case requestFailed(Error)
        case notImplemented

        public var debugDescription: String {
            switch self {
            case .notImplemented:
                return "Not Implemented"
            case .requestFailed(let error):
                return "Request failed: \(error)"
            }
        }
    }
}
