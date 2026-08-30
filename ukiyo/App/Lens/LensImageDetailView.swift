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
        if let image = lensImage.image {
          Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(.rect(cornerRadius: 16))
            .accessibilityLabel(
              lensImage.caption.isEmpty
                ? Text("Saved photo")
                : Text(verbatim: lensImage.caption)
            )
        }

        if !lensImage.caption.isEmpty {
          Text(lensImage.caption)
            .font(.title3)
        }

        Text(lensImage.createdAt, format: .dateTime.month().day().year())
          .font(.caption)
          .foregroundStyle(.secondary)
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
