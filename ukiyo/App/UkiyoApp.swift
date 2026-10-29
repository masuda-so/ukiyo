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
          #if DEBUG
          let monitorTransactions = !CommandLine.arguments.contains(
            "--disable-test-host-storekit-monitor"
          )
          if !monitorTransactions {
            print("StoreKit test host: automatic entitlement monitoring disabled.")
          }
          await environment.start(monitorTransactions: monitorTransactions)
          #else
          await environment.start()
          #endif
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
