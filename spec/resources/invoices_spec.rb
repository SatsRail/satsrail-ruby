# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Invoices do
  it "generates an invoice via POST /m/invoices/generate" do
    stub_request(:post, "#{base_url}/m/invoices/generate")
      .with(body: { order_id: "ord_1", payment_method: "lightning" })
      .to_return(**json_response(object: "invoice", id: "inv_1").merge(status: 201))

    result = client.invoices.generate(order_id: "ord_1", payment_method: "lightning")
    expect(result["id"]).to eq("inv_1")
  end

  it "omits payment_method when not provided" do
    stub_request(:post, "#{base_url}/m/invoices/generate")
      .with(body: { order_id: "ord_1" })
      .to_return(**json_response(object: "invoice", id: "inv_1").merge(status: 201))

    client.invoices.generate(order_id: "ord_1")
  end

  it "accepts required_confirmations for on-chain" do
    stub_request(:post, "#{base_url}/m/invoices/generate")
      .with(body: { order_id: "ord_1", payment_method: "onchain", required_confirmations: 3 })
      .to_return(**json_response(object: "invoice", id: "inv_1").merge(status: 201))

    client.invoices.generate(order_id: "ord_1", payment_method: "onchain", required_confirmations: 3)
  end

  it "sends Idempotency-Key" do
    stub_request(:post, "#{base_url}/m/invoices/generate")
      .with(headers: { "Idempotency-Key" => "k_xyz" })
      .to_return(**json_response(object: "invoice", id: "inv_1").merge(status: 201))

    client.invoices.generate(order_id: "ord_1", idempotency_key: "k_xyz")
  end

  it "retrieves an invoice" do
    stub_request(:get, "#{base_url}/m/invoices/inv_1")
      .to_return(**json_response(object: "invoice", id: "inv_1"))
    expect(client.invoices.retrieve("inv_1")["id"]).to eq("inv_1")
  end

  it "checks invoice status" do
    stub_request(:get, "#{base_url}/m/invoices/inv_1/status")
      .to_return(**json_response(status: "paid"))
    expect(client.invoices.status("inv_1")["status"]).to eq("paid")
  end
end
