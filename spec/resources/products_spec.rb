# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Products do
  it "lists products" do
    stub_request(:get, "#{base_url}/m/products")
      .to_return(**json_response(object: "list", data: []))
    client.products.list
  end

  it "retrieves a product by slug" do
    stub_request(:get, "#{base_url}/m/products/my-product")
      .to_return(**json_response(object: "product", slug: "my-product"))
    expect(client.products.retrieve("my-product")["slug"]).to eq("my-product")
  end

  it "creates with the product: wrapper" do
    stub_request(:post, "#{base_url}/m/products")
      .with(body: { product: { name: "Backup pack", price_cents: 10_000 } })
      .to_return(**json_response(object: "product", id: "pr_1").merge(status: 201))
    client.products.create(name: "Backup pack", price_cents: 10_000)
  end

  it "updates with the product: wrapper" do
    stub_request(:patch, "#{base_url}/m/products/pr_1")
      .with(body: { product: { price_cents: 12_000 } })
      .to_return(**json_response(object: "product", id: "pr_1"))
    client.products.update("pr_1", price_cents: 12_000)
  end

  it "deletes a product" do
    stub_request(:delete, "#{base_url}/m/products/pr_1").to_return(status: 204, body: "")
    expect(client.products.delete("pr_1")).to be_nil
  end

  it "retrieves the encryption key" do
    stub_request(:get, "#{base_url}/m/products/pr_1/key")
      .to_return(**json_response(key: "k_abc"))
    expect(client.products.get_key("pr_1")["key"]).to eq("k_abc")
  end

  it "rotates the key" do
    stub_request(:post, "#{base_url}/m/products/pr_1/rotate_key")
      .to_return(**json_response(old_key: "k_old", new_key: "k_new"))
    result = client.products.rotate_key("pr_1")
    expect(result["new_key"]).to eq("k_new")
  end

  it "clears the old key" do
    stub_request(:post, "#{base_url}/m/products/pr_1/clear_old_key")
      .to_return(**json_response(cleared: true))
    expect(client.products.clear_old_key("pr_1")["cleared"]).to eq(true)
  end
end
