import Combine

/**
 # NetworkMonitoring
 Protocol for service which observes status of network to notify as soon as network is online/available.
 */
@MainActor
protocol NetworkMonitoring {

    /// Network is reachable
    var isOnline: Bool { get }

    /// Combine publisher notifying on network update
    var isOnlinePublisher: AnyPublisher<Bool, Never> { get }

    /// Start service monitoring network
    func startMonitoring()

    /// Stop service monitoring network
    func stopMonitoring()
}
