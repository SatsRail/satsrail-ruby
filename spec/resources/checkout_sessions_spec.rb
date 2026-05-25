# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::CheckoutSessions do
  it "lists checkout sessions" do
    stub_request(:get, "#{base_url}/m/checkout_sessions")
      .to_return(**json_response(object: "list", data: []))
    client.checkout_sessions.list
  end

  it "retrieves a session" do
    stub_request(:get, "#{base_url}/m/checkout_sessions/cs_1")
      .to_return(**json_response(object: "checkout_session", id: "cs_1"))
    expect(client.checkout_sessions.retrieve("cs_1")["id"]).to eq("cs_1")
  end

  it "creates a session" do
    stub_request(:post, "#{base_url}/m/checkout_sessions")
      .with(body: { checkout_session: { amount_cents: 5000 } })
      .to_return(**json_response(object: "checkout_session", checkout_url: "https://pay.satsrail.com/x")
                   .merge(status: 201))

    result = client.checkout_sessions.create(amount_cents: 5000)
    expect(result["checkout_url"]).to include("satsrail.com")
  end

  it "validates metadata" do
    expect {
      client.checkout_sessions.create(amount_cents: 5000, metadata: "not-a-hash")
    }.to raise_error(ArgumentError)
  end
end
