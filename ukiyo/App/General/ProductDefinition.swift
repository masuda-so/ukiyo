import SwiftUI

/// Stable identifiers that must remain compatible with App Store records.
enum ProductIdentity {
  nonisolated static let identifier = "ukiyo"
  nonisolated static let bundleIdentifier = "llc.ether.\(identifier)"
}

/// Product-specific presentation, assistant, and legal configuration.
struct ProductDefinition {
  let identifier: String
  let bundleIdentifier: String
  let name: String
  let tagline: String
  let symbolName: String
  let accent: Color
  let assistantInputTitle: String
  let assistantActionTitle: String
  let assistantProgressTitle: String
  let assistantTitle: String
  let assistantOutputTitle: String
  let assistantInstructions: String
  let assistantPromptPrefix: String
  let settingsPrivacySummary: String
  let privacyPolicyURL: URL
  let termsOfUseURL: URL
  let supportURL: URL

  static let ukiyo = ProductDefinition(
    identifier: ProductIdentity.identifier,
    bundleIdentifier: ProductIdentity.bundleIdentifier,
    name: "Ukiyo",
    tagline: String(localized: "Turn a fleeting image into a story."),
    symbolName: "camera.aperture",
    accent: .pink,
    assistantInputTitle: String(localized: "An image idea or caption"),
    assistantActionTitle: String(localized: "Shape"),
    assistantProgressTitle: String(localized: "Shaping your copy…"),
    assistantTitle: String(localized: "Caption Studio"),
    assistantOutputTitle: String(localized: "Suggested copy"),
    assistantInstructions:
      "Help refine image concepts, captions, and accessible alt text. Avoid unsafe content, never invent visual facts absent from the input, and never claim that an image was generated.",
    assistantPromptPrefix:
      "Return a short title, caption, and accessible alt-text suggestion for this idea:",
    settingsPrivacySummary: String(
      localized: "Your captions and selected photos stay on this device."
    ),
    privacyPolicyURL: validatedURL(
      "https://ether-llc.com/apps/ukiyo/privacy/"
    ),
    termsOfUseURL: validatedURL(
      "https://ether-llc.com/apps/ukiyo/terms/"
    ),
    supportURL: validatedURL(
      "https://ether-llc.com/apps/ukiyo/support/"
    )
  )

  func localizedLegalURL(_ url: URL, for locale: Locale) -> URL {
    guard
      locale.language.languageCode?.identifier == "ja",
      url.host == "ether-llc.com",
      !url.path.hasPrefix("/ja/")
    else {
      return url
    }

    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
      return url
    }
    components.percentEncodedPath = "/ja\(components.percentEncodedPath)"
    return components.url ?? url
  }

  private static func validatedURL(_ value: String) -> URL {
    guard let url = URL(string: value) else {
      preconditionFailure("Invalid static URL: \(value)")
    }
    return url
  }
}
