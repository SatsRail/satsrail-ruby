# Changelog

All notable changes to the `satsrail` gem are documented here. This project follows [Semantic Versioning](https://semver.org/).

## [0.2.0] — 2026-05-25

### Fixed
- **API namespace** — every resource now targets the correct API namespace. Previous releases sent merchant requests to `/api/v1/{resource}`, but the SatsRail merchant API lives at `/api/v1/m/{resource}` and the public surface at `/api/v1/pub/{resource}`. Every previous call 404'd. `orders`, `invoices`, `payments`, `payment_requests`, `wallets`, `webhooks`, `checkout_sessions`, `merchant`, `catalog`, `subscription_plans` (now `/pub/`) and `api_tokens`/`products` (already correct) all route correctly.
- **Invoices#generate** — was posting to `/orders/:id/invoices`, which does not exist. Now hits `POST /m/invoices/generate` with `order_id` in the body, matching the portal route.

### Added
- **ProductTypes** — full CRUD (`list`, `retrieve`, `create`, `update`, `delete`).
- **MerchantDocuments** — read-only access (`list`, `retrieve`). Uploads and deletions are admin-only and intentionally not exposed.
- **Access** — `verify(access_token)` for content-delivery clients gating access after payment. Returns product/order/encryption-key on success.
- **Products** — `clear_old_key` to finalise a key rotation. CRUD methods (`list`, `retrieve`, `create`, `update`, `delete`) now mirror the rest of the SDK.
- **CheckoutSessions** — added `list` and `retrieve` (was create-only).
- **Orders#cancel** — alias for `delete` for clarity.
- **Idempotency** — `Orders#create`, `Invoices#generate`, and `PaymentRequests#create` accept `idempotency_key:`. Matches the three endpoints where the portal honors the `Idempotency-Key` header (24-hour dedupe window).
- **Metadata validation** — every `metadata:` parameter is validated against the portal's `HasMetadata` concern (max 50 keys, 40-char keys, 500-char string values). Violations raise `ArgumentError` client-side instead of bouncing off a 422.
- **SVG responses** — `Invoices#qr` now returns the raw SVG string rather than failing with a JSON parse error.

### Changed
- **Merchant** — `list_orders` and `list_payments` were removed. Those endpoints never existed; callers should use `client.orders.list` and `client.payments.list` directly.
- **Orders#create** — top-level vs nested body shaping is now declared via `TOP_LEVEL_KEYS` rather than inline. Behavior unchanged.

### Internal
- Extracted `SatsRail::ApiPath` with `.m(suffix)` / `.pub(suffix)` helpers so every resource declaration shows which API surface it targets. Keeps the merchant / public split visible.
- Extracted `SatsRail::Metadata` validator and `HttpClient.idempotency_headers` helper.
- HTTP client now distinguishes 204 No Content (returns `nil`) and `image/svg+xml` responses (returns the SVG body).

### Tooling
- **CI** — `.github/workflows/test.yml` runs RSpec on Ruby 3.0, 3.1, 3.2, 3.3, 3.4 for every push and PR.
- **Release** — `.github/workflows/release.yml` publishes on `v*` tags via RubyGems trusted publishing (OIDC, no `RUBYGEMS_API_KEY` to rotate). Verifies the tag matches `SatsRail::VERSION`.
- **Tests** — suite expanded from 11 examples to 85, covering every resource, helpers, error class, and the HTTP client.

## [0.1.0] — 2026-03-08

- Initial release.
