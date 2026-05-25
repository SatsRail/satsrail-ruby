# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::PaymentRequests do
  it "creates a payment request" do
    stub_request(:post, "#{base_url}/m/payment_requests")
      .with(body: { payment_request: { amount_cents: 5000, currency: "usd" } })
      .to_return(**json_response(object: "payment_request", id: "pr_1").merge(status: 201))

    result = client.payment_requests.create(amount_cents: 5000, currency: "usd")
    expect(result["id"]).to eq("pr_1")
  end

  it "passes the Idempotency-Key header" do
    stub_request(:post, "#{base_url}/m/payment_requests")
      .with(headers: { "Idempotency-Key" => "k_pr" })
      .to_return(**json_response(object: "payment_request", id: "pr_1").merge(status: 201))

    client.payment_requests.create(amount_cents: 5000, idempotency_key: "k_pr")
  end

  it "validates metadata" do
    expect {
      client.payment_requests.create(amount_cents: 5000, metadata: "not-a-hash")
    }.to raise_error(ArgumentError)
  end

  it "retrieves a payment request" do
    stub_request(:get, "#{base_url}/m/payment_requests/pr_1")
      .to_return(**json_response(object: "payment_request", id: "pr_1"))
    expect(client.payment_requests.retrieve("pr_1")["id"]).to eq("pr_1")
  end

  it "checks status" do
    stub_request(:get, "#{base_url}/m/payment_requests/pr_1/status")
      .to_return(**json_response(status: "pending"))
    expect(client.payment_requests.status("pr_1")["status"]).to eq("pending")
  end
end
