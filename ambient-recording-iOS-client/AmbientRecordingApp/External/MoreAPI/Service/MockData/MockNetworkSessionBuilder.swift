import Foundation

/**
 # MockNetworkSessionBuilding
 Protocol for factory which can build URL/network sessions.
 */
public final class MockNetworkSessionBuilder: NetworkSessionBuilding {

    /// Configurable option describing how mock network request should finish
    public var behavior: MockNetworkSession.Behavior = .succeed(.default)

    /// Build a new URL/network session.
    public func newSession() -> NetworkSession {
        MockNetworkSession(behavior: behavior)
    }
}

// MARK: URLSession
extension MockNetworkSession: NetworkSession { }
