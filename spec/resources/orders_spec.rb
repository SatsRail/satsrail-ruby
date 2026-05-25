# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Orders do
  it "lists orders" do
    stub_request(:get, "#{base_url}/m/orders")
      .to_return(**json_response(object: "list", data: []))
    expect(client.orders.list["object"]).to eq("list")
  end

  it "lists with pagination params on the query string" do
    stub_request(:get, "#{base_url}/m/orders?page=2&per_page=50")
      .to_return(**json_response(object: "list", data: []))
    client.orders.list(page: 2, per_page: 50)
  end

  it "creates an order with the order: wrapper" do
    stub_request(:post, "#{base_url}/m/orders")
      .with(body: { order: { total_amount_cents: 5000, currency: "usd" }, generate_invoice: true })
      .to_return(**json_response(object: "order", id: "ord_1").merge(status: 201))

    result = client.orders.create(total_amount_cents: 5000, currency: "usd", generate_invoice: true)
    expect(result["id"]).to eq("ord_1")
  end

  it "passes the Idempotency-Key header when provided" do
    stub_request(:post, "#{base_url}/m/orders")
      .with(headers: { "Idempotency-Key" => "k_abc" })
      .to_return(**json_response(object: "order", id: "ord_1").merge(status: 201))

    client.orders.create(total_amount_cents: 5000, idempotency_key: "k_abc")
  end

  it "validates metadata before sending" do
    expect {
      client.orders.create(total_amount_cents: 5000, metadata: { "k" * 41 => "v" })
    }.to raise_error(ArgumentError, /exceeds 40 characters/)
  end

  it "retrieves an order" do
    stub_request(:get, "#{base_url}/m/orders/ord_1")
      .to_return(**json_response(object: "order", id: "ord_1"))
    expect(client.orders.retrieve("ord_1")["id"]).to eq("ord_1")
  end

  it "supports expand on retrieve" do
    stub_request(:get, "#{base_url}/m/orders/ord_1?expand=invoice,payment")
      .to_return(**json_response(object: "order", id: "ord_1"))
    client.orders.retrieve("ord_1", expand: "invoice,payment")
  end

  it "updates with the order: wrapper" do
    stub_request(:patch, "#{base_url}/m/orders/ord_1")
      .with(body: { order: { tax_amount_cents: 100 } })
      .to_return(**json_response(object: "order", id: "ord_1"))
    client.orders.update("ord_1", tax_amount_cents: 100)
  end

  it "deletes an order" do
    stub_request(:delete, "#{base_url}/m/orders/ord_1").to_return(status: 204, body: "")
    expect(client.orders.delete("ord_1")).to be_nil
  end

  it "cancel is an alias for delete" do
    stub_request(:delete, "#{base_url}/m/orders/ord_1").to_return(status: 204, body: "")
    expect(client.orders.cancel("ord_1")).to be_nil
  end
end
