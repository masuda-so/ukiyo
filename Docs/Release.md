# Ukiyo release readiness

Status: pre-release. This document defines requirements and gates; it does not
set a submission or release date. Previous local build and test results are not
current release evidence and must not be reused for the final submission.

## v1 scope

- iOS 18 minimum deployment target with iPhone and iPad support.
- A private, local-first visual journal: system PhotosPicker selection, bounded
  image preparation, optional caption, library/detail, and deletion.
- Image preparation applies orientation, bounds the long dimension to 1,600
  pixels, encodes JPEG at quality 0.82, and intentionally does not preserve
  source metadata.
- SwiftData stores entries locally and uses external storage for prepared image
  data. There is no account, analytics, ads, cloud sync, or remote AI service.
- An explicitly invoked on-device caption/title/alt-text helper is available
  only when Apple Foundation Models are supported and Pro access is active.
- StoreKit 2 product loading, purchase, restore, verified-entitlement, and
  transaction-update handling for one non-renewing Daily Pass and Monthly/
  Yearly auto-renewing subscriptions.
- Privacy, Terms, Restore, and Manage Subscription surfaces are implemented.
- The local StoreKit configuration belongs to the shared Debug scheme and is
  excluded from the app target and release Archive.

## Current technical gate

Run one project at a time in this order: static inspection, build, non-StoreKit
tests, Analyze, then unsigned Archive inspection. Use the current stable Xcode,
a supported SDK, and an installed compatible Simulator runtime. Record the exact
toolchain and destination when these checks are rerun.

- [ ] Swift formatting, project/resource parsing, privacy/photo-access,
      Required Reason API, localization, and legal-URL checks complete.
- [ ] Debug build and non-StoreKit tests complete with the current stable Xcode.
- [ ] Release Analyze completes for the app target; warnings are reviewed.
- [ ] Unsigned Archive inspection confirms identity, minimum OS, SDK/toolchain,
      localization, privacy manifest, compiled icons, and absence of StoreKit
      configuration and test payloads.
- [ ] The final signed Archive is validated before TestFlight or submission.

## StoreKit and external environment gate

The nine StoreKit Test scenarios remain required: product loading; verified
purchase and finish; unfinished-transaction processing; restore; Daily Pass
boundary; Ask to Buy pending; refund revocation; Daily Pass repurchase from the
latest signed purchase date; and auto-renew cancellation with access through
expiration. The Daily Pass does not auto-renew or stack.

Complete StoreKit end-to-end checks with an Apple-distributed compatible
Simulator runtime, a compatible physical device, or TestFlight/App Store Connect
products. A local StoreKit failure is not sufficient evidence of production
behavior.

## Human and external release gate

- Configure the app record, version/build/SKU, Apple Distribution signing, and
  provisioning for `llc.ether.ukiyo` in App Store Connect.
- Create/localize all three products, set price/availability/review assets, put
  Monthly and Yearly in one same-level subscription group, and include first
  products with the app-version submission as required.
- Publish and anonymously verify the fixed public URLs:
  - Privacy: `https://ether-llc.com/apps/ukiyo/privacy/`
  - Terms: `https://ether-llc.com/apps/ukiyo/terms/`
  - Support: `https://ether-llc.com/apps/ukiyo/support/`
- Confirm App Store privacy, age rating, encryption/export compliance, content
  rights, regional legal answers, and the non-renewing pass device-clock policy.
- Test real representative photos, orientation, image size/quality, memory,
  deletion, iPhone/iPad layouts, VoiceOver, Dynamic Type, Japanese/English,
  offline/failure states, purchase, restore, and entitlement transitions.
- Prepare distinct Ukiyo screenshots, value proposition, and review notes that
  demonstrate the visual-journal concept and avoid guideline 4.3 duplication.
- Decide whether any prior Bundle ID requires a user export/import path; local
  SwiftData and purchases do not automatically transfer to a new app record.
- Complete signed Archive validation, TestFlight, compatible physical-device
  testing, and final human review. Signing/upload/publication remain external.

## Icon decision

Use `ukiyo/Resources/AppIcon.icon` as the sole app-icon source. Its locally
created, non-SF-Symbol foreground remains installed in the layered Icon Composer
asset. The current stable Xcode must render the supported appearances, and the
final Archive must contain the compiled icon. Inspect masks, appearances, and
small sizes on real devices; App Review makes the final determination.
