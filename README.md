# SatsRail Ruby SDK

[![Gem Version](https://img.shields.io/gem/v/satsrail.svg)](https://rubygems.org/gems/satsrail)
[![Tests](https://github.com/SatsRail/satsrail-ruby/actions/workflows/test.yml/badge.svg)](https://github.com/SatsRail/satsrail-ruby/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official Ruby SDK for the [SatsRail](https://www.satsrail.com/) Bitcoin payment API. Accept Bitcoin payments via Lightning Network, on-chain, and USDT with zero dependencies.

## Installation

Add to your Gemfile:

```ruby
gem "satsrail"
```

Or install directly:

```bash
gem install satsrail
```

Requires **Ruby 3.0+**.

## Quick Start

```ruby
require "satsrail"

SatsRail.configure do |config|
  config.api_key = "sk_live_..."
end

client = SatsRail::Client.new

session = client.checkout_sessions.create(
  amount_cents: 5000,
  currency: "usd",
  success_url: "https://mysite.com/thanks",
  cancel_url: "https://mysite.com/cancel"
)
puts session["checkout_url"] # Redirect your customer here
```

## Configuration

```ruby
# Option A: Global configuration
SatsRail.configure do |config|
  config.api_key = "sk_live_..."
  config.base_url = "https://app.satsrail.com/api/v1" # default
  config.timeout = 30 # seconds, default
end
client = SatsRail::Client.new

# Option B: Per-client configuration
client = SatsRail::Client.new(
  api_key: "sk_live_...",
  base_url: "https://app.satsrail.com/api/v1",
  timeout: 30
)
```

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `api_key` | `String` | `nil` | Your SatsRail API key |
| `base_url` | `String` | `https://app.satsrail.com/api/v1` | API base URL |
| `timeout` | `Integer` | `30` | Request timeout in seconds |

### Test Mode

Use test mode keys (`sk_test_...`) to create isolated test data:

```ruby
client = SatsRail::Client.new(api_key: "sk_test_...")
```

## API Reference

### Checkout Sessions

Create hosted checkout pages where customers complete payment.

```ruby
session = client.checkout_sessions.create(
  amount_cents: 5000,       # required — $50.00
  currency: "usd",          # optional
  success_url: "https://mysite.com/thanks",
  cancel_url: "https://mysite.com/cancel"
)
# session["checkout_url"] — redirect customer here
# session["id"], session["token"], session["expires_at"]
```

### Orders

Create and manage payment orders.

```ruby
# Create
order = client.orders.create(
  total_amount_cents: 5000,
  currency: "usd",
  items: [{ name: "Widget", price_cents: 5000, qty: 1 }],
  metadata: { order_ref: "PO-12345" },
  idempotency_key: "order-PO-12345" # optional — dedupes within 24h
  # generate_invoice: true,       — auto-generate invoice
  # payment_method: "lightning",
)

# List (paginated)
orders = client.orders.list(status: "pending", page: 1, per_page: 25)
# orders["data"] — array of order objects
# orders["meta"] — { "current_page", "total_pages", "total_count", ... }

# Retrieve (with optional expansion)
order = client.orders.retrieve("order_id", expand: "invoice,payment")

# Update
updated = client.orders.update("order_id", metadata: { note: "updated" })

# Cancel (alias: client.orders.cancel("order_id"))
client.orders.delete("order_id")
```

### Invoices

Generate and track invoices for orders.

```ruby
# Generate an invoice for an order
invoice = client.invoices.generate(
  order_id: "order_id",
  payment_method: "lightning",       # "lightning" | "onchain" | "usdt"
  required_confirmations: 1,         # on-chain only (1-6)
  idempotency_key: "invoice-1234"    # optional
)

# Retrieve
inv = client.invoices.retrieve("invoice_id")

# Check status
status = client.invoices.status("invoice_id")

# Get QR code (returns SVG string)
svg = client.invoices.qr("invoice_id")
```

### Payments (read-only)

View payment records.

```ruby
# List (paginated, with date filters)
payments = client.payments.list(
  page: 1,
  per_page: 25,
  start_date: "2026-01-01",
  end_date: "2026-01-31"
)

# Retrieve
payment = client.payments.retrieve("payment_id")
```

### Payment Requests

Unified API for Lightning/Bitcoin/USDT payments.

```ruby
# Create
pr = client.payment_requests.create(
  amount_cents: 1000,
  payment_method: "lightning",
  idempotency_key: "pr-tip-1234" # optional
)

# Retrieve
pr = client.payment_requests.retrieve("pr_id")

# Check status
status = client.payment_requests.status("pr_id")
```

### Wallets (read-only)

View merchant wallets.

```ruby
wallets = client.wallets.list
wallet = client.wallets.retrieve("wallet_id")
```

### Webhooks

Manage webhook endpoints for real-time event notifications.

```ruby
# Create (returns secret_key — save it!)
wh = client.webhooks.create(
  url: "https://mysite.com/webhooks",
  events: ["order.created", "invoice.paid", "payment.received"],
  description: "Production endpoint"
)
puts wh["secret_key"] # whsec_... — only shown once

# List (includes available_events)
webhooks = client.webhooks.list

# Retrieve
wh = client.webhooks.retrieve("webhook_id")

# Update
client.webhooks.update("webhook_id", url: "https://mysite.com/webhooks/v2", active: false)

# Delete
client.webhooks.delete("webhook_id")
```

### Merchant

```ruby
me = client.merchant.retrieve
```

To list a merchant's orders or payments, use `client.orders.list` and `client.payments.list` — they're already scoped to the authenticated merchant.

### Products

Products power the encrypted-content delivery flow. Identifiers accept both UUIDs and slugs.

```ruby
# CRUD
products = client.products.list
product  = client.products.retrieve("backup-pack-2026") # slug or UUID
created  = client.products.create(name: "Backup pack", price_cents: 10_000)
updated  = client.products.update("backup-pack-2026", price_cents: 12_000)
client.products.delete("backup-pack-2026")

# Encryption keys (sk_live_ only)
key      = client.products.get_key("backup-pack-2026")     # { "key" => "..." }
rotation = client.products.rotate_key("backup-pack-2026")  # { "old_key" => "...", "new_key" => "..." }
client.products.clear_old_key("backup-pack-2026")          # finalise rotation
```

### Product Types

```ruby
types = client.product_types.list
type  = client.product_types.retrieve("pt_id")
client.product_types.create(name: "Channel")
client.product_types.update("pt_id", name: "Channel v2")
client.product_types.delete("pt_id")
```

### Merchant Documents (read-only)

```ruby
docs = client.merchant_documents.list
doc  = client.merchant_documents.retrieve("doc_id")
```

Uploads and deletions are admin operations and are intentionally not exposed in this SDK.

### Access Verification

Server-to-server verification of a customer's macaroon access token. Used by content-delivery clients to gate access after payment. Requires `sk_live_`.

```ruby
result = client.access.verify("macaroon_v2_...")
# result["valid"]              => true / false
# result["remaining_seconds"]  => 3600
# result["product_id"]         => "pr_..." (on confirmed payment)
# result["order_id"]           => "ord_..."
# result["encryption_key"]     => "..."
# result["key_fingerprint"]    => "..."
```

### Subscription Plans (public)

Hits the public `/pub/subscription_plans` endpoint — no auth required, but the SDK sends the key anyway for consistency.

```ruby
plans = client.subscription_plans.list
```

### API Token Usage

```ruby
usage = client.api_tokens.usage("tok_id")
# usage["rpm_limit"], usage["current_rpm"], usage["monthly_request_count"]
```

## Idempotency

The portal honors `Idempotency-Key` on three endpoints — order creation, invoice generation, and payment request creation. Pass `idempotency_key:` to any of them:

```ruby
client.orders.create(total_amount_cents: 5000, idempotency_key: "order-PO-123")
client.invoices.generate(order_id: "ord_1", idempotency_key: "invoice-PO-123")
client.payment_requests.create(amount_cents: 5000, idempotency_key: "pr-tip-1")
```

Keys dedupe within a 24-hour window. The portal returns the original response for repeat calls.

## Metadata

Anywhere the API accepts a `metadata:` hash, the SDK validates it client-side against the portal's `HasMetadata` concern before sending. Invalid metadata raises `ArgumentError` immediately rather than bouncing off a 422.

| Constraint | Limit |
|---|---|
| Maximum number of keys | 50 |
| Maximum key length | 40 characters |
| Maximum value length | 500 characters |
| Value type | Anything stringifiable — values are stored as strings |

## Error Handling

All errors extend `SatsRail::Error` and include structured details:

```ruby
begin
  client.orders.create(total_amount_cents: -1, items: [])
rescue SatsRail::ValidationError => e
  puts e.status      # 422
  puts e.code        # "validation_error"
  puts e.message     # "Validation failed"
  puts e.details     # ["Total amount cents must be greater than 0"]
  puts e.request_id  # "req_..."
rescue SatsRail::AuthenticationError
  # 401 — bad API key
rescue SatsRail::NotFoundError
  # 404 — resource doesn't exist
rescue SatsRail::RateLimitError
  # 429 — slow down
rescue SatsRail::Error
  # Other API error
end
```

| Error Class | Status | When |
|-------------|--------|------|
| `SatsRail::AuthenticationError` | 401 | Invalid or missing API key |
| `SatsRail::NotFoundError` | 404 | Resource not found |
| `SatsRail::ValidationError` | 422 | Invalid request parameters |
| `SatsRail::RateLimitError` | 429 | Too many requests |
| `SatsRail::Error` | * | All other API errors |

## License

MIT — see [LICENSE](LICENSE).
