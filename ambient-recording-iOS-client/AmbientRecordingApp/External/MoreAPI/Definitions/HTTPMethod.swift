import Foundation

/**
 # HTTPMethod
 Basic value that you think iOS would define as a type-safe value type but doesn't.
 Defines how to query particular endpoint.
 https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods
 */
public enum HTTPMethod {
    case delete
    case get
    case head
    case patch
    case post
    case put
}

// MARK: CustomStringConvertible
extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .delete:
            return "DELTE"
        case .get:
            return "GET"
        case .head:
            return "HEAD"
        case .patch:
            return "PATCH"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        }
    }
}
