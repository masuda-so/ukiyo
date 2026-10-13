import PhotosUI
import SwiftUI

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
