import SwiftUI

struct ImageGenerationStatusCard: View {
  let title: LocalizedStringResource
  let message: LocalizedStringResource
  var actionTitle: LocalizedStringResource?
  var action: (() -> Void)?

  var body: some View {
    CardView {
      VStack(alignment: .leading, spacing: 12) {
        Label(title, systemImage: "wand.and.sparkles")
          .font(.headline)

        Text(message)
          .foregroundStyle(.secondary)

        if let actionTitle, let action {
          Button(actionTitle, action: action)
            .buttonStyle(.borderedProminent)
        }

        ImageGenerationDisclosure()
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

struct ImageGenerationDisclosure: View {
  var body: some View {
    Label(
      "Image Playground creates a new image using the selected photo as visual inspiration; it does not transform the original photo.",
      systemImage: "info.circle"
    )
    .font(.footnote)
    .foregroundStyle(.secondary)
  }
}
