import Foundation

/**
 # JSONEndpointRequest
 `APIEndpointRequest` implementation for an endpoint that takes and returns JSON values
 */
public struct JSONEndpointRequest<Request: Codable, Response: APIEndpointResponse>: APIEndpointRequest {

    /// How to contact server
    var httpMethod: HTTPMethod
    /// Address describing where to contact
    var url: URL
    /// Request body to send to server
    var body: Request?
    /// Headers for request
    var headers: [String: String]

    init(
        method: HTTPMethod,
        url: URL,
        body: Request? = nil,
        headers: [String : String] = [:]
    ) {
        self.httpMethod = method
        self.url = url
        self.body = body
        self.headers = headers
    }

    /// Build a `URLRequest` to send to server endpoint
    public func encode() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.description

        // Encode body as JSON
        if let body {
            let encoder = JSONEncoder()
            let data = try encoder.encode(body)
            urlRequest.httpBody = data
        }

        for header in headers.keys {
            urlRequest.setValue(headers[header], forHTTPHeaderField: header)
        }
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        return urlRequest
    }
}
