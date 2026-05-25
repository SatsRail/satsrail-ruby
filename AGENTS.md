# SatsRail Ruby SDK — AGENTS.md

Official Ruby SDK for the SatsRail Bitcoin payment API. Zero runtime dependencies.

## Tech Stack

- **Language:** Ruby 3.0+
- **Package:** `satsrail` gem on RubyGems (currently 0.2.0)
- **License:** MIT
- **CI:** GitHub Actions, RSpec matrix on Ruby 3.0–3.4
- **Release:** OIDC trusted publishing to RubyGems on `v*` tag

## API Surface

The SDK wraps the merchant (`/m/`) and public (`/pub/`) API namespaces.

| Resource | Operations |
|---|---|
| `checkout_sessions` | list, retrieve, create (+ metadata validation) |
| `orders` | list, retrieve, create (+ idempotency, metadata), update, delete (alias: cancel) |
| `invoices` | generate (+ idempotency), retrieve, status, qr (SVG) |
| `payments` | list, retrieve |
| `payment_requests` | create (+ idempotency, metadata), retrieve, status |
| `wallets` | list, retrieve |
| `webhooks` | list, retrieve, create, update, delete |
| `merchant` | retrieve (singular — list orders/payments via the dedicated resources) |
| `merchant_documents` | list, retrieve (uploads and deletions are admin-only) |
| `catalog` | retrieve, version |
| `subscription_plans` | list (public `/pub/` endpoint) |
| `products` | list, retrieve, create, update, delete + get_key, rotate_key, clear_old_key |
| `product_types` | list, retrieve, create, update, delete |
| `api_tokens` | usage |
| `access` | verify (server-to-server macaroon validation) |

## Architecture

- `lib/satsrail/api_path.rb` — `ApiPath.m(...)` / `ApiPath.pub(...)` — every resource declares its namespace explicitly. Wrong namespace 404s silently.
- `lib/satsrail/metadata.rb` — `Metadata.validate!` enforces `HasMetadata` constraints (50 keys / 40-char / 500-char) before the request.
- `lib/satsrail/http_client.rb` — transport. `idempotency_headers` helper. Handles `image/svg+xml` and `204 No Content` distinctly.
- `lib/satsrail/resources/base_resource.rb` — shared `list_request`, `create_request`, `retrieve_request`, `update_request`, `delete_request` for the standard CRUD pattern.

## Configuration

Supports global config (`SatsRail.configure`) or per-client (`SatsRail::Client.new`).

## Error Classes

All extend `SatsRail::Error`: `AuthenticationError` (401), `NotFoundError` (404), `ValidationError` (422), `RateLimitError` (429).

## Conventions

- Config options: `api_key`, `base_url`, `timeout`
- Test mode: use `sk_test_...` keys — picked up automatically by the portal
- Idempotency: pass `idempotency_key:` to `Orders#create`, `Invoices#generate`, `PaymentRequests#create` (24-hour dedupe)
- Metadata: validated client-side before the request
