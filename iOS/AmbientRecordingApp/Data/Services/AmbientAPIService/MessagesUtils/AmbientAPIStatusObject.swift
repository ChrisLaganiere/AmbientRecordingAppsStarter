import Foundation

/**
 # AmbientAPIStatus
 Status codes used in our API
 */
enum AmbientAPIStatus: Int, Codable {
    case success = 0
    case badRequest = 100
    case invalidEtag = 101
    case invalidCtag = 102
    case notFound = 404
}

/**
 # AmbientAPIStatusObject
 JSON status object used in our API
 */
struct AmbientAPIStatusObject: Codable {
    var statusCode: AmbientAPIStatus?
    var errorMessage: String?

    /// Translate to json key, if needed
    private enum CodingKeys: String, CodingKey {
        case statusCode = "code"
        case errorMessage = "error_message"
    }
}
