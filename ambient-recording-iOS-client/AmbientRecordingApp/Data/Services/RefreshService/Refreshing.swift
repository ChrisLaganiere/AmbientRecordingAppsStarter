import Foundation

/**
 # Refreshing
 Yum! Protocol for a service which keeps local cache up-to-date with server, syncing data bi-directionally
 */
@MainActor
protocol Refreshing {
    /// Refresh all appointments right away
    func refreshAll() async
    /// Start syncing app cache with server
    func startRefreshing()
    /// Stop syncing app cache with server
    func stopRefreshing()
}
