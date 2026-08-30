import SwiftUI

enum AppSection: Hashable {
  case lens
  case assistant
  case pro
  case settings
}

struct AppRootView: View {
  @Environment(AppEnvironment.self) private var environment
  @State private var selection: AppSection = .lens

  var body: some View {
    TabView(selection: $selection) {
      Tab("Lens", systemImage: "camera.filters", value: .lens) {
        LensView()
      }

      Tab("Assistant", systemImage: "sparkles", value: .assistant) {
        AssistantView(selection: $selection)
      }

      Tab("Pro", systemImage: "crown", value: .pro) {
        PaywallView()
      }

      Tab("Settings", systemImage: "gearshape", value: .settings) {
        SettingsView()
      }
    }
    .tint(environment.product.accent)
  }
}

#Preview {
  AppRootView()
    .environment(AppEnvironment.preview)
    .sampleDataContainer()
}
