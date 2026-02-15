# SatsRail Ruby SDK

[![Gem Version](https://img.shields.io/gem/v/satsrail.svg)](https://rubygems.org/gems/satsrail)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Official Ruby SDK for the [SatsRail](https://satsrail.com) Bitcoin payment API. Accept Bitcoin payments via Lightning Network, on-chain, and USDT with zero dependencies.

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
  metadata: { order_ref: "PO-12345" }
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

# Cancel
client.orders.delete("order_id")
```

### Invoices

Generate and track invoices for orders.

```ruby
# Generate an invoice for an order
invoice = client.invoices.generate(
  order_id: "order_id",
  payment_method: "lightning" # "lightning" | "onchain" | "usdt"
)

# Retrieve
inv = client.invoices.retrieve("invoice_id")

# Check status
status = client.invoices.status("invoice_id")

# Get QR code
qr = client.invoices.qr("invoice_id")
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
  payment_method: "lightning"
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

Access authenticated merchant data.

```ruby
# Get merchant profile
me = client.merchant.retrieve

# List merchant orders
orders = client.merchant.list_orders(page: 1)

# List merchant payments
payments = client.merchant.list_payments(page: 1)
```

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
