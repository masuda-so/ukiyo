import Foundation

struct ImageGenerationNotice: Identifiable {
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
