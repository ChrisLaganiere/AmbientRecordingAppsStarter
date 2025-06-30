import CoreData
import Combine

/**
 # FetchableResultsPublisher
 Object which fetches `Fetchable` items from a Core Data managed object context, publishing results.

 ### Usage

 1. Create a `FetchableResultsPublisher` with filter and sort matching your needs.
 2. Set up your subscribers to relevant publisher on the new instance.
 3. Call `beginFetch()` to start fetching. Call `endFetching()` to stop fetching.

 ### Advanced

 You could alternatively use `diffPublisher` to subscribe to notifications more efficiently, perhaps when throttling and combining publishers, and then access `fetchedObjects` when ready to make use of results.
 */
@MainActor
public class FetchableResultsPublisher<ResultType>: NSObject, NSFetchedResultsControllerDelegate, FetchableResultsPublishing where ResultType : NSManagedObject, ResultType : Fetchable {

    // MARK: Properties

    /// Define query criteria, determining which entities are fetched
    public var filter: ResultType.Filter? {
        didSet {
            frc.fetchRequest.predicate = filter?.predicate
            try? beginFetch()
        }
    }

    /// Define sort of fetched results
    public var sort: ResultType.Sort? {
        didSet {
            frc.fetchRequest.sortDescriptors = sort?.sortDescriptors ?? []
            try? beginFetch()
        }
    }

    /// Define sort of fetched results
    public var fetchLimit: Int {
        didSet {
            frc.fetchRequest.fetchLimit = fetchLimit
            try? beginFetch()
        }
    }

    /// Define sort of fetched results
    public var fetchOffset: Int {
        didSet {
            frc.fetchRequest.fetchOffset = fetchOffset
            try? beginFetch()
        }
    }

    /// Retrieved objects
    @MainActor
    public var fetchedObjects: [ResultType] {
        return frc.fetchedObjects ?? []
    }

    /// Publisher vending entities matching filter and sort
    public var fetchedObjectsPublisher: any Publisher<[ResultType], Never> {
        $diff.map { [frc] _ in
            frc.fetchedObjects ?? []
        }
    }
    /// Publisher vending only the identifiers for results, which are smaller and thread-safe.
    /// This is a less-expensive publisher which will still notify you whenever results change.
    public var diffPublisher: any Publisher<CollectionDifference<NSManagedObjectID>?, Never> {
        $diff
    }

    // MARK: Private Properties

    /// Context with objects to search
    private let moc: NSManagedObjectContext
    /// Controller fetching Core Data objects
    private let frc: NSFetchedResultsController<ResultType>

    /// Results of fetch request
    @Published
    private var diff: CollectionDifference<NSManagedObjectID>? = nil

    // MARK: Methods

    public init(
        filter: ResultType.Filter? = nil,
        sort: ResultType.Sort? = nil,
        moc: NSManagedObjectContext,
        fetchLimit: Int = 0,
        fetchOffset: Int = 0
    ) {
        self.filter = filter
        self.sort = sort
        self.moc = moc
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset

        frc = NSFetchedResultsController(
            fetchRequest: ResultType.fetchRequest(
                predicate: filter?.predicate,
                sortDescriptors: sort?.sortDescriptors ?? [],
                fetchLimit: fetchLimit,
                fetchOffset: fetchOffset
            ),
            managedObjectContext: moc,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
    }

    /// Executes the fetch request on the store to get entities
    public func beginFetch() throws {
        // Activates underlying FRC monitoring for changes by setting delegate
        // https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller#overview
        frc.delegate = self

        try frc.performFetch()
        self.diff = nil
    }

    /// Stop actively listening for changes to query, pausing fetch
    public func endFetch() {
        // Pause underlying FRC by setting delegate to nil
        // https://developer.apple.com/documentation/coredata/nsfetchedresultscontroller#overview
        frc.delegate = nil
    }

    // MARK: NSFetchedResultsControllerDelegate

    nonisolated public func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChangeContentWith diff: CollectionDifference<NSManagedObjectID>
    ) {
        Task {
            await self.save(diff: diff)
        }
    }

    // MARK: Private Methods

    private func save(diff: CollectionDifference<NSManagedObjectID>) {
        self.diff = diff
    }
}
