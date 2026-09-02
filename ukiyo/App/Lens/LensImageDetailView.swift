import SwiftData
import SwiftUI

struct LensImageDetailView: View {
  let lensImage: LensImage

  @Environment(\.dismiss) private var dismiss
  @Environment(\.modelContext) private var modelContext
  @State private var isShowingDeleteConfirmation = false
  @State private var deletionError: String?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        if lensImage.isAIGenerated {
          Label("AI Generated with Image Playground", systemImage: "sparkles")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
        }

        if let image = lensImage.image {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 16))
            .accessibilityLabel(
              lensImage.caption.isEmpty
                ? primaryImageAccessibilityLabel
                : primaryImageAccessibilityLabelWithCaption
            )
        }

        if lensImage.isAIGenerated {
          Text(
            "This is a new AI-created image inspired by the source photo, not a transformed version of it."
          )
          .font(.footnote)
          .foregroundStyle(.secondary)
        }

        if !lensImage.caption.isEmpty {
          Text(lensImage.caption)
            .font(.title3)
        }

        Text(lensImage.createdAt, format: .dateTime.month().day().year())
          .font(.caption)
          .foregroundStyle(.secondary)

        if lensImage.isAIGenerated, let sourceImage = lensImage.sourceImage {
          Divider()

          Text("Source Photo")
            .font(.headline)

          Image(uiImage: sourceImage)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 16))
            .accessibilityLabel("Source photo used in Image Playground")
        }
      }
      .padding()
    }
    .navigationTitle("Image")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .destructiveAction) {
        Button("Delete", systemImage: "trash", role: .destructive) {
          isShowingDeleteConfirmation = true
        }
      }
    }
    .confirmationDialog(
      "Delete Image",
      isPresented: $isShowingDeleteConfirmation,
      titleVisibility: .visible
    ) {
      Button("Delete Image", role: .destructive) {
        deleteImage()
      }
    } message: {
      Text("This image will be permanently deleted.")
    }
    .alert("Delete Failed", isPresented: isShowingDeletionError) {
      Button("OK", role: .cancel) {
        deletionError = nil
      }
    } message: {
      Text(deletionError ?? String(localized: "Please try again."))
    }
  }

  private var isShowingDeletionError: Binding<Bool> {
    Binding(
      get: { deletionError != nil },
      set: { if !$0 { deletionError = nil } }
    )
  }

  private var primaryImageAccessibilityLabel: Text {
    lensImage.isAIGenerated ? Text("Saved AI-generated image") : Text("Saved photo")
  }

  private var primaryImageAccessibilityLabelWithCaption: Text {
    lensImage.isAIGenerated
      ? Text("Saved AI-generated image: \(lensImage.caption)")
      : Text(verbatim: lensImage.caption)
  }

  private func deleteImage() {
    do {
      try modelContext.performTransactionOrRollback {
        modelContext.delete(lensImage)
      }
      dismiss()
    } catch {
      deletionError = error.localizedDescription
    }
  }
}
