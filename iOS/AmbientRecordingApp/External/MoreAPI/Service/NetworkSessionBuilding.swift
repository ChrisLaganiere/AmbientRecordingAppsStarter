import Foundation

/**
 # NetworkSessionBuilding
 Protocol for factory which can build URL/network sessions.
 */
protocol NetworkSessionBuilding {
    /// Build a new URL/network session.
    func newSession() -> NetworkSession
}
