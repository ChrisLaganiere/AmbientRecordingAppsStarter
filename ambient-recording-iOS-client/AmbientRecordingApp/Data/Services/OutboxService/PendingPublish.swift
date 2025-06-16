import Foundation

/**
 # PendingPublish
 Protocol for values describing what changes are intended to be published at a later date.
 The specifics about what will be published depend on your use case. For example, we might
 have a collection of actions that can be performed, or a collection of properties to be published.

 Intended changes should be mergeable. For example, several actions might be enqueued on top
 of each other, represented by merging the action values together.
 */
protocol PendingPublish: Codable, CustomDebugStringConvertible {
    /// Add new publish intention to existing publish intention
    func merge(_ other: Self) -> Self
}
