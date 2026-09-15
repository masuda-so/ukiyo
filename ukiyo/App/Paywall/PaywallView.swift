import StoreKit
import SwiftUI
import ImagePlayground

struct PaywallView: View {
  var body: some View {
    if #available(iOS 18.1, *) {
      ImagePlaygroundPaywallView()
    } else {
      PaywallContent(supportsImagePlayground: false)
    }
  }
}

@available(iOS 18.1, *)
private struct ImagePlaygroundPaywallView: View {
  @Environment(\.supportsImagePlayground) private var supportsImagePlayground

  var body: some View {
    PaywallContent(supportsImagePlayground: supportsImagePlayground)
  }
}

private struct PaywallContent: View {
  let supportsImagePlayground: Bool
  @Environment(AppEnvironment.self) private var environment
  @Environment(\.locale) private var locale
  @State private var isShowingSubscriptionManagement = false

  private var canOfferPro: Bool {
    UkiyoAccessPolicy.canOfferPro(
      assistantAvailable: environment.isAIAvailable,
      imageGenerationAvailable: supportsImagePlayground
    )
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 18) {
          Image(
            systemName: environment.isPremium
              ? "checkmark.seal.fill"
              : environment.product.symbolName
          )
          .font(.system(size: 48))
          .foregroundStyle(environment.product.accent)
          .accessibilityHidden(true)

          Text(
            environment.isPremium
              ? "\(environment.product.name) Pro is active" : "\(environment.product.name) Pro"
          )
          .font(.title.bold())

          Text(environment.product.tagline)
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)

          if !canOfferPro {
            CardView {
              Label(
                "Neither writing assistance nor image generation is available on this device. Paid plans can’t be purchased until a Pro feature becomes available.",
                systemImage: "exclamationmark.triangle"
              )
              .foregroundStyle(.secondary)
            }
          } else {
            if !environment.isAIAvailable {
              Label(
                "Image generation is available. Writing assistance is unavailable on this device or for the current language.",
                systemImage: "info.circle"
              )
              .foregroundStyle(.secondary)
            } else if !supportsImagePlayground {
              Label(
                "Writing assistance is available. Image generation is unavailable on this device, language, or region.",
                systemImage: "info.circle"
              )
              .foregroundStyle(.secondary)
            }

            StoreView(
              ids: ProductID.offeredProductIDs(
                dailyPassIsActive: environment.isProductActive(
                  UkiyoCommerceCatalog.dailyPassProductID
                )
              )
            )
            .storeButton(.hidden, for: .cancellation)
            .storeButton(.hidden, for: .restorePurchases)

            if let expirationDate = environment.entitlements.expirationDates[
              UkiyoCommerceCatalog.dailyPassProductID
            ], environment.isProductActive(UkiyoCommerceCatalog.dailyPassProductID) {
              Text(
                "Daily Pass active until \(expirationDate.formatted(date: .abbreviated, time: .shortened))"
              )
              .font(.footnote.bold())
              .foregroundStyle(environment.product.accent)
            }
          }

          RestorePurchasesButton()

          Button("Manage Subscription") {
            isShowingSubscriptionManagement = true
          }

          HStack(spacing: 16) {
            Link(
              "Privacy Policy",
              destination: environment.product.localizedLegalURL(
                environment.product.privacyPolicyURL,
                for: locale
              )
            )
            Link(
              "Terms of Use",
              destination: environment.product.localizedLegalURL(
                environment.product.termsOfUseURL,
                for: locale
              )
            )
          }
          .font(.footnote)

        }
        .padding(24)
      }
      .navigationTitle("Pro")
      .manageSubscriptionsSheet(isPresented: $isShowingSubscriptionManagement)
    }
  }

}
