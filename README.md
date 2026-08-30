# Ukiyo

Ukiyo is a local-first visual journal for saving selected images and captions,
with optional on-device writing assistance.

## Main navigation

- Lens
- Assistant
- Pro
- Settings

## Core experience

The system Photos picker exposes only the selected item. Imported images are
orientation-corrected, resized to a maximum 1,600-pixel dimension, compressed,
and stored with SwiftData external storage. Saved images can be reviewed and
deleted.

## Intelligence and commerce

The assistant uses Apple Foundation Models on supported devices and languages.
The local StoreKit configuration provides:

- `llc.ether.ukiyo.pro.daily`: non-renewing 24-hour Daily Pass.
- `llc.ether.ukiyo.pro.monthly`: auto-renewable monthly plan.
- `llc.ether.ukiyo.pro.yearly`: auto-renewable yearly plan.

App Store Connect product records, production prices, and review metadata remain
external release tasks.

## Documentation

- [Product scope](Docs/Product.md)
- [Privacy](Docs/Privacy.md) and [Terms](Docs/Terms.md)
- [Implementation references](Docs/References.md)
- [Release readiness](Docs/Release.md)
- [App Store submission record](Docs/App-Store-Submission.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)

Published public routes:

- `https://ether-llc.com/apps/ukiyo/privacy/`
- `https://ether-llc.com/apps/ukiyo/terms/`
- `https://ether-llc.com/apps/ukiyo/support/`

Deployment, signing, upload, and release are not repository-local steps.
