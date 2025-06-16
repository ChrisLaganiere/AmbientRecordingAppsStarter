import CoreData

/**
 # CoreDataPersistenceController
 Sets up a persistent container for a Core Data stack.
 */
public final class CoreDataPersistenceController: CoreDataPersisting {
    /// A context where entities live, for use displayingn views on the main thread
    @MainActor
    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    /// Shared writer moc where write changes to store are serialized in a private worker queue.
    /// Write changes are serialized to avoid merge conflicts:
    /// https://stackoverflow.com/a/45206964
    private lazy var backgroundWriteMoc = newBackgroundContext()

    // MARK: Private Properties

    /// Manager with responsibilities that cover fetching and saving entities in Core Data
    private let persistentContainer: NSPersistentContainer

    /// Schema for entities that can live in persistent container.
    private let managedObjectModel: NSManagedObjectModel

    // MARK: Life Cycle

    public init(
        config: Config = .defaultURL,
        name: String,
        managedObjectModel: NSManagedObjectModel
    ) throws {
        let container = NSPersistentContainer(
            name: name,
            managedObjectModel: managedObjectModel
        )

        // Configure store description
        guard let description = container.persistentStoreDescriptions.first else {
            throw PersistenceControllerError.missingPersistentStoreDescription
        }

        switch config {
        case .inMemory:
            description.url = URL(string: "/dev/null")
        case .url(let url):
            description.url = url
        case .defaultURL:
            // NO-OP: No change needed
            break
        }

        // Setting necessary for CoreDataSpotlightDelegate and Swift Data interop
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        // Setting necessary for CoreDataSpotlightDelegate
        description.type = NSSQLiteStoreType

        self.managedObjectModel = managedObjectModel
        self.persistentContainer = container
    }

    // MARK: API

    /// Set up controller. You must call this before making use of this controller.
    public func load() throws {
        // Load stores
        var loadError: NSError?

        persistentContainer.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                loadError = error
            }

            // Configure contexts
            self?.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }

        if let loadError {
            throw loadError
        }
    }

    /// Perform actions with a private-queue managed object context that loads into persistent store
    public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let moc = backgroundWriteMoc
        moc.perform {
            block(moc)
        }
    }

    /// Perform actions with a private-queue managed object context that feeds into persistent store (async)
    public func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T {
        let moc = backgroundWriteMoc
        return try await moc.perform {
            try block(moc)
        }
    }

    /// Build writing context for persistent container that can be used in a private background worker thread.
    public func newBackgroundContext(merge: NSMergePolicyType) -> NSManagedObjectContext {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.automaticallyMergesChangesFromParent = true
        backgroundContext.mergePolicy = NSMergePolicy(merge: merge)
        return backgroundContext
    }
}

// MARK: - Definitions
public extension CoreDataPersistenceController {
    /// Configuration options for persistence controller
    enum Config {
        /// In-memory only; do not persist
        case inMemory
        /// Persist at custom location, with file URL
        case url(URL)
        /// Persist at default app location
        case defaultURL
    }

    /// Errors that can occur during persistence
    enum PersistenceControllerError: String, Error, CustomDebugStringConvertible {
        case missingPersistentStoreDescription

        public var debugDescription: String {
            rawValue
        }
    }
}
