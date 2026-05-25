# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail do
  describe ".configure" do
    it "stores global configuration" do
      SatsRail.configure do |config|
        config.api_key = api_key
      end
      expect(SatsRail.configuration.api_key).to eq(api_key)
    end

    it "exposes default base_url and timeout" do
      expect(SatsRail.configuration.base_url).to eq(base_url)
      expect(SatsRail.configuration.timeout).to eq(30)
    end
  end

  describe SatsRail::Client do
    it "raises without an API key" do
      expect { SatsRail::Client.new }.to raise_error(SatsRail::AuthenticationError)
    end

    it "picks up the global API key" do
      SatsRail.configure { |c| c.api_key = api_key }
      expect { SatsRail::Client.new }.not_to raise_error
    end

    it "wires every resource accessor" do
      c = SatsRail::Client.new(api_key: api_key)
      %i[orders invoices payments payment_requests wallets checkout_sessions
         webhooks merchant merchant_documents catalog subscription_plans
         products product_types api_tokens access].each do |name|
        expect(c.public_send(name)).not_to be_nil, "client##{name} missing"
      end
    end

    it "sets Authorization, Accept, and User-Agent on every request" do
      stub_request(:get, "#{base_url}/m/payments")
        .with(headers: {
                "Authorization" => "Bearer #{api_key}",
                "Accept" => "application/json",
                "User-Agent" => "satsrail-ruby/#{SatsRail::VERSION}"
              })
        .to_return(**json_response({ object: "list", data: [] }))

      client.payments.list
    end
  end
end
