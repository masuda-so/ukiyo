import PhotosUI
import SwiftData
import SwiftUI
import UIKit

#if canImport(ImagePlayground)
  import ImagePlayground
#endif

/// Adds an optional Pro image-generation path without changing the free photo-journal flow.
struct UkiyoImageGenerationView: View {
  @Environment(AppEnvironment.self) private var environment

  let imageSelection: PhotosPickerItem?
  let caption: String
  let showProOptions: () -> Void
  let didSave: () -> Void

  var body: some View {
    if environment.isPremium {
      supportedGenerationView
    } else {
      ImageGenerationStatusCard(
        title: "Ukiyo-Inspired Image",
        message: "Image Playground generation is a Pro feature.",
        actionTitle: "View Pro options",
        action: showProOptions
      )
    }
  }

  @ViewBuilder
  private var supportedGenerationView: some View {
    #if canImport(ImagePlayground)
      if #available(iOS 18.1, *) {
        AvailableUkiyoImageGenerationView(
          imageSelection: imageSelection,
          caption: caption,
          didSave: didSave
        )
      } else {
        ImageGenerationStatusCard(
          title: "Image Playground Unavailable",
          message:
            "Ukiyo-inspired generation requires Image Playground on a supported Apple Intelligence device."
        )
      }
    #else
      ImageGenerationStatusCard(
        title: "Image Playground Unavailable",
        message: "This build does not include Apple’s Image Playground framework."
      )
    #endif
  }
}

private struct ImageGenerationStatusCard: View {
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

        generationDisclosure
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

@available(iOS 18.1, *)
private struct AvailableUkiyoImageGenerationView: View {
  @Environment(AppEnvironment.self) private var environment
  @Environment(\.modelContext) private var modelContext
  @Environment(\.supportsImagePlayground) private var supportsImagePlayground

  let imageSelection: PhotosPickerItem?
  let caption: String
  let didSave: () -> Void

  @State private var sourceImageData: Data?
  @State private var generatedImageData: Data?
  @State private var isPreparingSource = false
  @State private var isImagePlaygroundPresented = false
  @State private var notice: ImageGenerationNotice?
  @State private var generationTask: Task<Void, Never>?

  var body: some View {
    CardView {
      VStack(alignment: .leading, spacing: 16) {
        Label("Ukiyo-Inspired Image", systemImage: "wand.and.sparkles")
          .font(.headline)

        if !supportsImagePlayground {
          Label(
            "Image Playground isn’t available on this device, language, or region.",
            systemImage: "exclamationmark.triangle"
          )
          .foregroundStyle(.secondary)
        } else if let generatedImageData, let sourceImageData {
          generatedDraft(
            sourceImageData: sourceImageData,
            generatedImageData: generatedImageData
          )
        } else if isPreparingSource {
          HStack(spacing: 12) {
            ProgressView()
            Text("Preparing the source photo…")
          }
        } else {
          Text(
            "Choose a photo, then use Apple’s system interface to create and review a new ukiyo-e/woodblock-inspired image. The selected photo is visual inspiration, not an image that the system transforms."
          )
          .foregroundStyle(.secondary)

          Button("Open Image Playground", systemImage: "apple.intelligence") {
            prepareAndPresentImagePlayground()
          }
          .buttonStyle(.borderedProminent)
          .tint(environment.product.accent)
          .disabled(imageSelection == nil)
        }

        generationDisclosure
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .imagePlaygroundSheet(
      isPresented: $isImagePlaygroundPresented,
      concept: generationConcept,
      sourceImage: sourceImage
    ) { url in
      receiveGeneratedImage(at: url)
    } onCancellation: {
      notice = .cancelled
    }
    .ukiyoImagePlaygroundStyle()
    .alert(item: $notice) { notice in
      Alert(
        title: Text(notice.title),
        message: Text(notice.message),
        dismissButton: .default(Text("OK"))
      )
    }
    .onChange(of: imageSelection) { oldSelection, newSelection in
      guard oldSelection != newSelection else { return }
      resetDraft()
    }
    .onDisappear {
      cancelGeneration()
    }
  }

  private var sourceImage: Image? {
    guard let sourceImageData, let image = UIImage(data: sourceImageData) else {
      return nil
    }
    return Image(uiImage: image)
  }

  private var generationConcept: String {
    String(localized: "Japanese ukiyo-e woodblock-print style")
  }

  private func generatedDraft(
    sourceImageData: Data,
    generatedImageData: Data
  ) -> some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("AI-Generated Draft", systemImage: "sparkles")
        .font(.subheadline.weight(.semibold))

      HStack(alignment: .top, spacing: 12) {
        draftImage(data: sourceImageData, title: "Source Photo")
        draftImage(data: generatedImageData, title: "Generated Image")
      }

      Text(
        "The result is a new AI-created image inspired by the selected photo, not a transformed version of that photo."
      )
      .font(.footnote)
      .foregroundStyle(.secondary)

      HStack {
        Button("Save AI Image", systemImage: "square.and.arrow.down") {
          saveGeneratedImage()
        }
        .buttonStyle(.borderedProminent)
        .tint(environment.product.accent)

        Button("Discard Draft", role: .destructive) {
          discardGeneratedImage()
        }
        .buttonStyle(.bordered)
      }
    }
  }

  private func draftImage(data: Data, title: LocalizedStringResource) -> some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title)
        .font(.caption.weight(.semibold))
      if let image = UIImage(data: data) {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .frame(maxWidth: .infinity)
          .aspectRatio(1, contentMode: .fit)
          .clipped()
          .clipShape(.rect(cornerRadius: 12))
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func prepareAndPresentImagePlayground() {
    guard environment.isPremium, supportsImagePlayground, let imageSelection else {
      return
    }

    generationTask?.cancel()
    notice = nil
    isPreparingSource = true
    generationTask = Task {
      defer {
        isPreparingSource = false
        generationTask = nil
      }

      do {
        guard
          let transfer = try await imageSelection.loadTransferable(type: LensImageTransfer.self),
          imageSelection == self.imageSelection
        else {
          return
        }
        try Task.checkCancellation()
        // LensImageTransfer has already orientation-corrected, bounded, and encoded this data.
        let preparedSourceData = transfer.data
        guard UIImage(data: preparedSourceData) != nil else {
          notice = .sourceUnavailable
          return
        }

        switch ImagePreparation.imagePlaygroundSourceValidation(for: preparedSourceData) {
        case .valid:
          break
        case .invalid:
          notice = .sourceUnavailable
          return
        case .tooSmall:
          notice = .sourceTooSmall
          return
        }

        sourceImageData = preparedSourceData
        generatedImageData = nil
        isImagePlaygroundPresented = true
      } catch is CancellationError {
        return
      } catch {
        notice = .sourceUnavailable
      }
    }
  }

  private func receiveGeneratedImage(at url: URL) {
    do {
      // Image Playground owns this temporary URL, so copy its data before returning.
      let data = try Data(contentsOf: url)
      guard !data.isEmpty, UIImage(data: data) != nil, sourceImageData != nil else {
        notice = .resultUnavailable
        return
      }
      generatedImageData = data
    } catch {
      notice = .resultUnavailable
    }
  }

  private func saveGeneratedImage() {
    guard let sourceImageData, let generatedImageData else {
      notice = .resultUnavailable
      return
    }

    let lensImage = LensImage(
      caption: caption.trimmingCharacters(in: .whitespacesAndNewlines),
      imageData: generatedImageData,
      sourceImageData: sourceImageData,
      provenance: .imagePlayground
    )

    do {
      try modelContext.performTransactionOrRollback {
        modelContext.insert(lensImage)
      }
      discardGeneratedImage()
      didSave()
    } catch {
      notice = .saveFailed
    }
  }

  private func discardGeneratedImage() {
    generatedImageData = nil
    sourceImageData = nil
  }

  private func resetDraft() {
    cancelGeneration()
    notice = nil
    generatedImageData = nil
    sourceImageData = nil
  }

  private func cancelGeneration() {
    generationTask?.cancel()
    generationTask = nil
    isImagePlaygroundPresented = false
    isPreparingSource = false
  }
}

private struct ImageGenerationNotice: Identifiable {
  let id: String
  let title: String
  let message: String

  static let cancelled = ImageGenerationNotice(
    id: "cancelled",
    title: String(localized: "Creation Cancelled"),
    message: String(localized: "No generated image was saved.")
  )

  static let sourceUnavailable = ImageGenerationNotice(
    id: "source-unavailable",
    title: String(localized: "Photo Unavailable"),
    message: String(localized: "The selected photo couldn’t be prepared for Image Playground.")
  )

  static let sourceTooSmall = ImageGenerationNotice(
    id: "source-too-small",
    title: String(localized: "Photo Too Small"),
    message: String(
      localized:
        "Image Playground expects a source photo that is at least 384 by 384 pixels. Choose a larger photo."
    )
  )

  static let resultUnavailable = ImageGenerationNotice(
    id: "result-unavailable",
    title: String(localized: "Generated Image Unavailable"),
    message: String(
      localized: "Ukiyo couldn’t receive that generated image. Try again in Image Playground.")
  )

  static let saveFailed = ImageGenerationNotice(
    id: "save-failed",
    title: String(localized: "Save Failed"),
    message: String(localized: "The generated image couldn’t be saved. Please try again.")
  )
}

@ViewBuilder
private var generationDisclosure: some View {
  Label(
    "Image Playground creates a new image using the selected photo as visual inspiration; it does not transform the original photo.",
    systemImage: "info.circle"
  )
  .font(.footnote)
  .foregroundStyle(.secondary)
}

#if canImport(ImagePlayground)
  private extension View {
    @ViewBuilder
    func ukiyoImagePlaygroundStyle() -> some View {
      if #available(iOS 18.4, *) {
        imagePlaygroundGenerationStyle(.illustration, in: [.illustration])
      } else {
        self
      }
    }
  }
#endif
