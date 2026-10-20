import SwiftData
import SwiftUI

@main
struct UkiyoApp: App {
  @Environment(\.scenePhase) private var scenePhase
  @State private var environment = AppEnvironment()
  @State private var dataContainer = DataContainer()

  var body: some Scene {
    WindowGroup {
      AppRootView()
        .environment(environment)
        .environment(dataContainer)
        .modelContainer(dataContainer.modelContainer)
        .task {
          await environment.start()
        }
        .task(id: scenePhase) {
          guard scenePhase == .active, environment.hasLoadedInitialState else {
            return
          }
          await environment.refreshAIAvailability()
        }
    }
  }
}
