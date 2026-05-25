# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::HttpClient do
  describe ".idempotency_headers" do
    it "returns empty when key is nil" do
      expect(described_class.idempotency_headers(nil)).to eq({})
    end

    it "wraps the key in an Idempotency-Key header" do
      expect(described_class.idempotency_headers("k_1")).to eq("Idempotency-Key" => "k_1")
    end

    it "stringifies non-string keys" do
      expect(described_class.idempotency_headers(42)).to eq("Idempotency-Key" => "42")
    end
  end

  describe "response handling" do
    it "returns nil on 204 No Content" do
      stub_request(:delete, "#{base_url}/m/orders/ord_1").to_return(status: 204, body: "")
      expect(client.orders.delete("ord_1")).to be_nil
    end

    it "returns the raw SVG body for image/svg+xml responses" do
      svg = "<svg xmlns='http://www.w3.org/2000/svg'></svg>"
      stub_request(:get, "#{base_url}/m/invoices/inv_1/qr")
        .to_return(status: 200, body: svg, headers: { "Content-Type" => "image/svg+xml" })

      expect(client.invoices.qr("inv_1")).to eq(svg)
    end

    it "raises on non-2xx SVG responses" do
      stub_request(:get, "#{base_url}/m/invoices/missing/qr")
        .to_return(status: 404, body: "", headers: { "Content-Type" => "image/svg+xml" })

      expect { client.invoices.qr("missing") }.to raise_error(SatsRail::Error)
    end

    it "raises Error with the parsed body on 5xx" do
      stub_request(:get, "#{base_url}/m/payments")
        .to_return(**json_response({ error: { message: "boom", code: "internal" } }).merge(status: 500))

      expect { client.payments.list }.to raise_error(SatsRail::Error) do |e|
        expect(e.status).to eq(500)
        expect(e.code).to eq("internal")
        expect(e.message).to eq("boom")
      end
    end

    it "raises a fast error on invalid JSON" do
      stub_request(:get, "#{base_url}/m/payments")
        .to_return(status: 200, body: "not-json", headers: { "Content-Type" => "application/json" })

      expect { client.payments.list }.to raise_error(SatsRail::Error, /Invalid JSON/)
    end
  end
end
