# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail do
  let(:api_key) { "sk_test_abc123" }
  let(:base_url) { "https://app.satsrail.com/api/v1" }

  describe ".configure" do
    it "stores global configuration" do
      SatsRail.configure do |config|
        config.api_key = api_key
      end
      expect(SatsRail.configuration.api_key).to eq(api_key)
    end
  end

  describe SatsRail::Client do
    subject(:client) { SatsRail::Client.new(api_key: api_key) }

    it "raises without an API key" do
      expect { SatsRail::Client.new }.to raise_error(SatsRail::AuthenticationError)
    end

    describe "#orders" do
      it "lists orders" do
        stub_request(:get, "#{base_url}/orders")
          .to_return(status: 200, body: '{"object":"list","data":[],"meta":{}}',
                     headers: { "Content-Type" => "application/json" })

        result = client.orders.list
        expect(result["object"]).to eq("list")
      end

      it "creates an order" do
        stub_request(:post, "#{base_url}/orders")
          .to_return(status: 201, body: '{"object":"order","id":"ord_1"}',
                     headers: { "Content-Type" => "application/json" })

        result = client.orders.create(total_amount_cents: 5000, items: [])
        expect(result["id"]).to eq("ord_1")
      end

      it "retrieves an order" do
        stub_request(:get, "#{base_url}/orders/ord_1")
          .to_return(status: 200, body: '{"object":"order","id":"ord_1"}',
                     headers: { "Content-Type" => "application/json" })

        result = client.orders.retrieve("ord_1")
        expect(result["id"]).to eq("ord_1")
      end

      it "deletes an order" do
        stub_request(:delete, "#{base_url}/orders/ord_1")
          .to_return(status: 204, body: "")

        expect(client.orders.delete("ord_1")).to be_nil
      end
    end

    describe "#checkout_sessions" do
      it "creates a session" do
        stub_request(:post, "#{base_url}/checkout_sessions")
          .to_return(status: 201, body: '{"object":"checkout_session","checkout_url":"https://pay.satsrail.com/x"}',
                     headers: { "Content-Type" => "application/json" })

        result = client.checkout_sessions.create(amount_cents: 5000)
        expect(result["checkout_url"]).to include("satsrail.com")
      end
    end

    describe "#webhooks" do
      it "creates a webhook" do
        stub_request(:post, "#{base_url}/webhooks")
          .to_return(status: 201, body: '{"object":"webhook","id":"wh_1","secret_key":"whsec_abc"}',
                     headers: { "Content-Type" => "application/json" })

        result = client.webhooks.create(url: "https://example.com", events: ["payment.received"])
        expect(result["secret_key"]).to eq("whsec_abc")
      end
    end

    describe "error handling" do
      it "raises AuthenticationError on 401" do
        stub_request(:get, "#{base_url}/orders")
          .to_return(status: 401, body: '{"error":{"code":"unauthorized","message":"Bad key","status":401}}',
                     headers: { "Content-Type" => "application/json" })

        expect { client.orders.list }.to raise_error(SatsRail::AuthenticationError)
      end

      it "raises NotFoundError on 404" do
        stub_request(:get, "#{base_url}/orders/nope")
          .to_return(status: 404, body: '{"error":{"code":"not_found","message":"Not found","status":404}}',
                     headers: { "Content-Type" => "application/json" })

        expect { client.orders.retrieve("nope") }.to raise_error(SatsRail::NotFoundError)
      end

      it "raises ValidationError on 422" do
        stub_request(:post, "#{base_url}/orders")
          .to_return(status: 422, body: '{"error":{"code":"validation_error","message":"Invalid","status":422,"details":["bad"]}}',
                     headers: { "Content-Type" => "application/json" })

        expect { client.orders.create(total_amount_cents: -1, items: []) }
          .to raise_error(SatsRail::ValidationError) { |e| expect(e.details).to eq(["bad"]) }
      end
    end
  end
end
