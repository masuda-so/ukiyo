# Ukiyo App Store submission record

Status: pre-submission. This defines gates, not a submission or release date.

## App identity

- Name: Ukiyo
- Bundle ID: `llc.ether.ukiyo`
- Minimum iOS: 18.0; iPhone and iPad
- App record/SKU/version/build/category/age rating/copyright/export compliance/
  content rights: confirm in App Store Connect against the final Archive

## In-App Purchases

| Product ID | Type | Local contract |
| --- | --- | --- |
| `llc.ether.ukiyo.pro.daily` | Non-renewing subscription | Pro 24 hours from latest verified purchase date; no stacking |
| `llc.ether.ukiyo.pro.monthly` | Auto-renewable subscription | Pro while verified entitlement is active |
| `llc.ether.ukiyo.pro.yearly` | Auto-renewable subscription | Pro while verified entitlement is active |

Monthly/Yearly share one same-level subscription group. Human ASC work must
confirm product type, localization, price, availability, tax/category, review
assets, and first-product submission. Local StoreKit data is not distributed.

## Fixed public URLs

- Privacy: `https://ether-llc.com/apps/ukiyo/privacy/`
- Terms: `https://ether-llc.com/apps/ukiyo/terms/`
- Support: `https://ether-llc.com/apps/ukiyo/support/`

The app points to Privacy, Terms, and Support. Deploy all pages and verify
anonymous mobile access outside the local network before submission;
publication is external.

## Privacy and photo access

- The system PhotosPicker exposes only the item selected by the user. Ukiyo does
  not request unrestricted photo-library access.
- Selected image data/captions remain in local SwiftData/external storage. The app
  has no account, analytics/ads, remote AI/content store, cloud sync, automatic
  upload, or image generation.
- Image preparation bounds the long dimension to 1,600 pixels, encodes JPEG at
  quality 0.82, applies orientation, and intentionally does not preserve source
  metadata. Review output quality on real representative images.
- `PrivacyInfo.xcprivacy` declares no tracking/collected data. Source and
  dependency assumptions must be rechecked against Apple's current Required
  Reason API list and the final Archive before confirming App Store privacy
  answers.
- A human must confirm privacy, age-rating, content rights, encryption/export,
  photo/copyright responsibility, and regional legal answers.

## Review notes to prepare

- Show system selection, explicit loading, prepared local save, caption, library,
  detail, and deletion with the free path available.
- Explain that Pro only adds an explicitly invoked on-device caption/title/alt-text
  helper and does not inspect an image unless described by the user.
- Explain unsupported Foundation Models behavior and Daily Pass device-clock policy.
- Show Restore, Manage Subscription, Privacy, Terms, and distinct Ukiyo visual-
  journal screenshots/copy for guideline 4.3.
- State that there is no account/review login.

## Icon record

Submit `ukiyo/Resources/AppIcon.icon`, which contains the selected locally
created, non-SF-Symbol family foreground. Confirm the built icon at required
sizes and supported appearances with the current stable Xcode. App Review makes
the final determination.

## Technical gate

- [ ] Static privacy, photo-access, localization, and legal-URL checks complete.
- [ ] Debug build and non-StoreKit tests complete with the current stable Xcode
      and an installed compatible Simulator runtime.
- [ ] Release Analyze completes and all warnings are reviewed.
- [ ] Unsigned Archive inspection confirms the app identity, privacy manifest,
      localization, icon, and exclusion of StoreKit/test payloads.
- [ ] Nine StoreKit E2E scenarios complete on a compatible runtime, device, or
      TestFlight build.
- [ ] Real PhotosPicker, orientation, image quality/size, memory, deletion, iPad,
      VoiceOver, Dynamic Type, localization, and failure-state checks pass.
- [ ] Signed validation/TestFlight, public URLs, metadata, privacy/IAP answers,
      screenshots/review notes, and final human review are complete.

No signing, upload, publication, or external message is performed without
separate authorization.
