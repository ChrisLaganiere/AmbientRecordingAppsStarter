import SwiftUI

@MainActor
@main
struct AmbientRecordingApp: App {

    let dependencies = AmbientRecordingAppDataDependencies.default()

    init() {
        self.dependencies.setUp()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(dependencies: dependencies)
                .onAppear {
                    Task {
                        // Refresh appointments data on launch
                        await self.dependencies.refreshService.refreshAll()
                        // Start polling regularly for appointments data
                        self.dependencies.refreshService.startRefreshing()
                    }
                }
                .onDisappear {
                    Task {
                        // Clean up: stop polling regularly for appointments data
                        self.dependencies.refreshService.stopRefreshing()
                    }
                }
        }
    }
}
