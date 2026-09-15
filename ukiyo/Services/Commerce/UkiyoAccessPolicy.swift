import Foundation

/// Maps verified StoreKit entitlements to Ukiyo's product access.
enum UkiyoAccessPolicy {
  /// Offer Pro when at least one of its independently supported features is usable.
  nonisolated static func canOfferPro(
    assistantAvailable: Bool,
    imageGenerationAvailable: Bool
  ) -> Bool {
    assistantAvailable || imageGenerationAvailable
  }

  /// Returns the access level granted by the current entitlements.
  static func accessLevel(
    for entitlements: EntitlementSnapshot,
    at date: Date = .now
  ) -> AccessLevel {
    grantsProAccess(for: entitlements, at: date) ? .pro : .free
  }

  /// Returns whether the current entitlements grant Pro access.
  static func grantsProAccess(
    for entitlements: EntitlementSnapshot,
    at date: Date = .now
  ) -> Bool {
    entitlements.hasPremiumAccess(in: UkiyoCommerceCatalog.catalog, at: date)
  }
}
