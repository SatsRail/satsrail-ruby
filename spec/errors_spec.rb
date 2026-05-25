# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Error do
  it "raises AuthenticationError on 401" do
    stub_request(:get, "#{base_url}/m/orders")
      .to_return(**json_response(error: { code: "unauthorized", message: "Bad key" }).merge(status: 401))
    expect { client.orders.list }.to raise_error(SatsRail::AuthenticationError)
  end

  it "raises NotFoundError on 404 and exposes request_id" do
    stub_request(:get, "#{base_url}/m/orders/nope")
      .to_return(**json_response(error: { code: "not_found", message: "Not found", request_id: "req_1" })
                   .merge(status: 404))
    expect { client.orders.retrieve("nope") }.to raise_error(SatsRail::NotFoundError) do |e|
      expect(e.request_id).to eq("req_1")
    end
  end

  it "raises ValidationError on 422 with details" do
    stub_request(:post, "#{base_url}/m/orders")
      .to_return(**json_response(error: { code: "validation_error", message: "Invalid", details: ["bad"] })
                   .merge(status: 422))
    expect { client.orders.create(total_amount_cents: -1, items: []) }
      .to raise_error(SatsRail::ValidationError) { |e| expect(e.details).to eq(["bad"]) }
  end

  it "raises RateLimitError on 429" do
    stub_request(:get, "#{base_url}/m/orders")
      .to_return(**json_response(error: { code: "rate_limited", message: "Slow down" }).merge(status: 429))
    expect { client.orders.list }.to raise_error(SatsRail::RateLimitError)
  end

  it "falls back to generic Error on 5xx" do
    stub_request(:get, "#{base_url}/m/orders")
      .to_return(**json_response(error: { message: "boom" }).merge(status: 502))
    expect { client.orders.list }.to raise_error(SatsRail::Error)
  end
end
