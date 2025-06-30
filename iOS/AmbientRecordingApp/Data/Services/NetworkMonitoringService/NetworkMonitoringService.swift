import Combine
import Network

/**
 # NetworkMonitoring
 Service which observes status of network to notify as soon as network is online/available.
 */
@MainActor
final class NetworkMonitoringService: NetworkMonitoring {

    // MARK: Properties

    /// Network is reachable
    @Published
    private(set) var isOnline: Bool = false

    /// Combine publisher notifying on network update
    var isOnlinePublisher: AnyPublisher<Bool, Never> {
        $isOnline.eraseToAnyPublisher()
    }

    // MARK: Private Properties

    /// System util for monitoring network status
    private let monitor: NWPathMonitor = .init()

    /// Internal state flag to prevent misuse
    private var isMonitoring: Bool = false

    // MARK: Methods

    /// Start service monitoring network
    func startMonitoring() {
        guard !isMonitoring else {
            assertionFailure("Misuse of NetworkMonitoringService")
            return
        }
        monitor.pathUpdateHandler = { [weak self] path in
            Task { [weak self] in
                await self?.setOnline(path.status == .satisfied)
            }
        }
        monitor.start(queue: DispatchQueue.main)
        isMonitoring = true
    }

    /// Stop service monitoring network
    func stopMonitoring() {
        monitor.cancel()
        isMonitoring = false
    }

    /// Helper method for setting `isOnline` property (which is MainActor-bound)
    private func setOnline(_ online: Bool) {
        self.isOnline = online
    }
}
