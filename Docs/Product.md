# Ukiyo

Ukiyo is a local-first creative lens for image ideas, captions, and visual history.
It includes Photos picker import, explicit loading states, captions, and a local
visual library.

## Initial navigation

- Lens
- Assistant
- Pro
- Settings

## Commerce baseline

- `llc.ether.ukiyo.pro.daily`: non-renewing Daily Pass with 24 hours of access.
- `llc.ether.ukiyo.pro.monthly`: auto-renewable monthly plan.
- `llc.ether.ukiyo.pro.yearly`: auto-renewable yearly plan.

The Daily Pass never renews automatically. App Store Connect products and pricing
must be configured and reviewed before these plans can be sold.
Its 24-hour expiration is calculated locally from StoreKit's verified purchase date
and the device wall clock. This release doesn't use a server-authoritative clock.
The on-device assistant is the initial Pro capability; the core app remains usable
without a purchase. An active Daily Pass cannot be repurchased or stacked.

## Implementation ownership

- Apple Foundation Models integration is owned by this application.
- The app-local AI client and Ukiyo-specific prompt remain inside this repository.
- StoreKit product loading, purchases, restoration, and entitlement handling are
  implemented locally by this application.
- Daily, Monthly, and Yearly plans follow the common Ether plan shape while their
  product identifiers and App Store configuration remain app-specific.
