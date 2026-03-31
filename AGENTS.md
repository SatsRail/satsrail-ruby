# SatsRail Ruby SDK — AGENTS.md

Official Ruby SDK for the SatsRail Bitcoin payment API. Zero dependencies.

## Tech Stack

- **Language:** Ruby 3.0+
- **Package:** `satsrail` gem on RubyGems
- **License:** MIT

## API Surface

The SDK wraps these resource endpoints:
- `checkout_sessions` — create hosted checkout pages
- `orders` — CRUD + list (paginated)
- `invoices` — generate, retrieve, status, QR
- `payments` — list + retrieve (read-only)
- `payment_requests` — create, retrieve, status
- `wallets` — list + retrieve (read-only)
- `webhooks` — CRUD + list
- `merchant` — profile, orders, payments

## Configuration

Supports global config (`SatsRail.configure`) or per-client (`SatsRail::Client.new`).

## Error Classes

All extend `SatsRail::Error`: `AuthenticationError` (401), `NotFoundError` (404), `ValidationError` (422), `RateLimitError` (429).

## Conventions

- Config options: `api_key`, `base_url`, `timeout`
- Test mode: use `sk_test_...` keys
