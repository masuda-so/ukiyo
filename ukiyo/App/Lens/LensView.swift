import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct LensView: View {
  @Environment(AppEnvironment.self) private var environment
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \LensImage.createdAt, order: .reverse)
  private var lensImages: [LensImage]

  @StateObject private var viewModel = ProfileModel()
  @State private var caption = ""
  @State private var isSaving = false
  @State private var persistenceError: String?
  @State private var saveTask: Task<Void, Never>?

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 24) {
          photoPicker
          imageLibrary
        }
        .padding(20)
      }
      .navigationTitle("Ukiyo")
      .alert("Save Failed", isPresented: isShowingPersistenceError) {
        Button("OK", role: .cancel) {
          persistenceError = nil
        }
      } message: {
        Text(persistenceError ?? String(localized: "Please try again."))
      }
    }
    .onChange(of: viewModel.imageSelection) { oldSelection, newSelection in
      guard oldSelection != newSelection else {
        return
      }
      cancelSave()
    }
    .onDisappear {
      cancelSave()
    }
  }

  private var photoPicker: some View {
    CardView {
      VStack(spacing: 16) {
        selectedImagePreview

        TextField("Caption", text: $caption, axis: .vertical)
          .lineLimit(2...5)

        HStack {
          PhotosPicker(
            selection: $viewModel.imageSelection,
            matching: .images,
            photoLibrary: .shared()
          ) {
            Label("Choose Photo", systemImage: "photo.on.rectangle")
          }
          .buttonStyle(.bordered)

          Button("Save", systemImage: "square.and.arrow.down") {
            cancelSave()
            saveTask = Task {
              await save()
            }
          }
          .buttonStyle(.borderedProminent)
          .tint(environment.product.accent)
          .disabled(viewModel.imageSelection == nil || isSaving)
        }
      }
    }
  }

  private var selectedImagePreview: some View {
    ProfileImage(imageState: viewModel.imageState)
      .scaledToFit()
      .frame(maxWidth: .infinity, minHeight: 240, maxHeight: 360)
      .background(.quaternary, in: .rect(cornerRadius: 16))
      .clipShape(.rect(cornerRadius: 16))
      .accessibilityLabel(
        caption.isEmpty
          ? Text("Selected photo")
          : Text("Selected photo: \(caption)")
      )
  }

  @ViewBuilder
  private var imageLibrary: some View {
    if lensImages.isEmpty {
      ContentUnavailableView(
        "No Images Yet",
        systemImage: "photo.stack",
        description: Text("Saved photos will appear here.")
      )
    } else {
      LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 140), spacing: 12)],
        spacing: 12
      ) {
        ForEach(lensImages) { lensImage in
          NavigationLink {
            LensImageDetailView(lensImage: lensImage)
          } label: {
            if let image = lensImage.image {
              Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 160)
                .clipped()
                .clipShape(.rect(cornerRadius: 16))
                .accessibilityLabel(
                  lensImage.caption.isEmpty
                    ? Text("Saved photo")
                    : Text(verbatim: lensImage.caption)
                )
            }
          }
          .buttonStyle(.plain)
        }
      }
    }
  }

  @MainActor
  private func save() async {
    guard let imageSelection = viewModel.imageSelection else {
      return
    }

    isSaving = true
    defer { isSaving = false }

    do {
      guard
        let lensImageTransfer = try await imageSelection.loadTransferable(
          type: LensImageTransfer.self
        ),
        imageSelection == viewModel.imageSelection
      else {
        return
      }
      try Task.checkCancellation()

      let lensImage = LensImage(
        caption: caption.trimmingCharacters(in: .whitespacesAndNewlines),
        imageData: lensImageTransfer.data
      )

      try modelContext.performTransactionOrRollback {
        modelContext.insert(lensImage)
      }
      caption = ""
      viewModel.imageSelection = nil
    } catch is CancellationError {
      return
    } catch {
      persistenceError = error.localizedDescription
    }
  }

  @MainActor
  private func cancelSave() {
    saveTask?.cancel()
    saveTask = nil
  }

  private var isShowingPersistenceError: Binding<Bool> {
    Binding(
      get: { persistenceError != nil },
      set: { if !$0 { persistenceError = nil } }
    )
  }
}

#Preview {
  LensView()
    .environment(AppEnvironment.preview)
    .sampleDataContainer()
}
