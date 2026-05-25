# Contributing to satsrail-ruby

Thanks for your interest in improving the SatsRail Ruby SDK.

## Project shape

This gem is a thin Ruby wrapper over the SatsRail HTTP API. It does not implement business logic — it forwards calls to `app.satsrail.com`. When the API changes, this wrapper has to follow.

- Resources live in `lib/satsrail/resources/`. One file per top-level API resource.
- Every resource declares its `resource_path` via `ApiPath.m("/...")` (merchant, `sk_*` / `pk_*` auth) or `ApiPath.pub("/...")` (public/embed) — never raw strings. The wrong namespace fails silently with a 404. Refer to the portal's `config/routes.rb` for the authoritative path list.
- HTTP transport, error handling, and headers are centralised in `lib/satsrail/http_client.rb`.

## Hard rule: no admin endpoints

This SDK only targets `/m/` and `/pub/`. Never `/admin/`. Admin routes are operator-only (`ak_*` tokens, cross-merchant access, audit-tracked lifecycle ops) and are not part of the public API contract. If a merchant-facing capability is currently admin-only, the right fix is a new `/m/` route in the portal — not an SDK call into `/admin/`.

PRs that wrap an admin operation will be closed. See `docs/portal/api-namespaces.md` in the parent monorepo for the full rationale.

## Local development

```bash
bundle install
bundle exec rspec
```

To exercise against staging, set the base URL:

```ruby
client = SatsRail::Client.new(api_key: "sk_test_...", base_url: "https://staging.satsrail.com/api/v1")
```

## Adding a resource

1. Find the route in the portal API. Confirm the namespace (`/m/` or `/pub/`).
2. Add `lib/satsrail/resources/<resource>.rb` with a class inheriting from `BaseResource`.
3. Use `ApiPath.m(...)` / `ApiPath.pub(...)` for the path.
4. Wrap request bodies the way the controller expects (`{ order: {...} }`, `{ webhook: {...} }`, etc.).
5. If the resource accepts metadata, call `Metadata.validate!(params[:metadata])` before issuing the request.
6. If the endpoint honors `Idempotency-Key`, accept an `idempotency_key:` keyword and pass `HttpClient.idempotency_headers(key)` as headers.
7. Wire the resource into `lib/satsrail.rb` and `lib/satsrail/client.rb`.
8. Add a `spec/resources/<resource>_spec.rb` covering every method.

## Versioning

Semantic Versioning. New resources or methods are minor bumps. Any change to a method name, parameter name, or HTTP semantics is a major bump — callers in the wild rely on the surface staying stable.

Update `CHANGELOG.md` in the same PR.

## Pull requests

- Keep PRs small and focused. One resource per PR is fine.
- Don't bundle dep bumps with surface changes.
- Run `bundle exec rspec` before requesting review.
- Smoke-test against a real `sk_test_*` key when changing HTTP semantics.

## Reporting issues

Open an issue at [github.com/SatsRail/satsrail-ruby/issues](https://github.com/SatsRail/satsrail-ruby/issues). Include the method called, the input you passed, and the error returned.
