import CoreData

/**
 # PublishingIntention
 Protocol for entity which can persist intended changes to be published to server at a later time.
 For example, we might save work while offline, which can be published when back online again!
 */
protocol PublishingIntention: NSManagedObject, Identifiable {
    /// Information about what to publish
    associatedtype PublishIntention: PendingPublish

    /// Encoded data about what to publish
    var pendingItem: PendingItem? { get set }
}

// MARK: Helpers
extension PublishingIntention {
    /// Helper for accessing info about publishing intention
    var pendingPublishIntention: PublishIntention? {
        PublishIntention.fromJSONData(pendingItem?.publishIntentionData)
    }

    /// Mark entity with publish intention for data that should be uploaded
    func savePublishIntention(
        _ publishIntention: PublishIntention,
        moc: NSManagedObjectContext
    ) {
        var publishIntention = publishIntention

        if let other = pendingPublishIntention {
            print("Adding to publish intention for \(type(of: self)) \(self.id): \(publishIntention.debugDescription)")
            publishIntention = publishIntention.merge(other)
        }
        else if pendingItem == nil {
            print("Creating publish intention for \(type(of: self)) \(self.id): \(publishIntention.debugDescription)")
            pendingItem = PendingItem(context: moc)
        }

        /// Persist info about what customer intends to do
        pendingItem?.publishIntentionData = publishIntention.asSortedJSONData

        /// Save version tag so we can clearn this data when publish to serversucceeds
        pendingItem?.etag = UUID().uuidString
    }

    /// Remove publish intention from an entity
    func clearPublishIntention(moc: NSManagedObjectContext) {
        if let pendingItem {
            print("Removing publish intention for \(type(of: self)) \(self.id)")
            moc.delete(pendingItem)
        }
    }
}
