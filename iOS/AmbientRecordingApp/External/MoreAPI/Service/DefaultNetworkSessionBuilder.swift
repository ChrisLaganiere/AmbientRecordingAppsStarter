import Foundation

/**
 # DefaultNetworkSessionBuilder
 Implementation of `NetworkSessionBuilding` with default `URLSession` implementation, for your production app.
 */
public final class DefaultNetworkSessionBuilder: NetworkSessionBuilding {

    /// Build a new URL/network session.
    public func newSession() -> NetworkSession {
        URLSession.shared
    }
}

// MARK: URLSession
extension URLSession: NetworkSession { }
