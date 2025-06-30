import CoreData

/**
 # AmbientRecordingAppDataDependencies
 Data services which make the app go
 */
@MainActor
final class AmbientRecordingAppDataDependencies {

    /// Service providing integration with Ambient server
    let ambientAPIService: any AmbientAPIServing
    /// Service recording audio and saving to cache
    let audioRecordingService: any AudioRecording
    /// Service observing network status for changes
    let networkMonitoringService: any NetworkMonitoring
    /// Service refreshing data regularly to ensure sync is up-to-date
    let refreshService: any Refreshing
    /// Service responsible for publishing locally cached changes to server
    let outboxService: any OutboxServing
    /// Controller of persistent app cache
    let persistenceController: CoreDataPersistenceController

    init(
        ambientAPIService: any AmbientAPIServing,
        audioRecordingService: any AudioRecording,
        networkMonitoringService: any NetworkMonitoring,
        refreshService: any Refreshing,
        outboxService: any OutboxServing,
        persistenceController: CoreDataPersistenceController
    ) {
        self.ambientAPIService = ambientAPIService
        self.audioRecordingService = audioRecordingService
        self.networkMonitoringService = networkMonitoringService
        self.refreshService = refreshService
        self.outboxService = outboxService
        self.persistenceController = persistenceController
    }

    /// Do initial set up as required for dependencies
    func setUp() {
        // Chore: set up Core Data stack on app launch
        do {
            try persistenceController.load()
        }
        catch {
            print("Failed to load persistence controller: \(error)")
        }

        // Fun: set up Outbox for syncing changes up to server based on network status
        outboxService.publishPendingItemsWhenOnline(networkMonitoringService)
    }
}

// MARK: Available configurations
extension AmbientRecordingAppDataDependencies {

    // Here is an easy spot to provide different configurations for the app.
    // You might set up different debug situations here by mocking out various
    // services. Since they are all referenced by protocol, any part of the app
    // can be mocked here for any purpose.

    /// Configuration for production apps connecting to server
    static func `default`() -> AmbientRecordingAppDataDependencies {

        // All services for the app are assembled here,
        // with dependency injection

        let apiService = APIService()

        let managedObjectModel = NSManagedObjectModel.mergedModel(
            from: [Bundle(for: self)]
        )!

        let persistenceController = (try? CoreDataPersistenceController(
            name: "AmbientRecordingApp",
            managedObjectModel: managedObjectModel
        ))!

        let ambientAPIService = AmbientAPIService(
            dependencies: .init(
                apiService: apiService,
                persistenceController: persistenceController
            )
        )

        let outboxService = OutboxService(
            dependencies: .init(
                ambientAPIService: ambientAPIService, 
                persistenceController: persistenceController
            )
        )

        let refreshService = RefreshService(
            dependencies: .init(
                ambientAPIService: ambientAPIService
            )
        )

        let networkMonitoringService = NetworkMonitoringService()

        let audioRecordingService = AudioRecordingService(
            dependencies: .init(
                outboxService: outboxService,
                persistenceController: persistenceController
            )
        )

        return AmbientRecordingAppDataDependencies(
            ambientAPIService: ambientAPIService,
            audioRecordingService: audioRecordingService,
            networkMonitoringService: networkMonitoringService,
            refreshService: refreshService,
            outboxService: outboxService,
            persistenceController: persistenceController
        )
    }
}
