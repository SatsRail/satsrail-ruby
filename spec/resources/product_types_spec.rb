# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::ProductTypes do
  it "lists product types" do
    stub_request(:get, "#{base_url}/m/product_types")
      .to_return(**json_response(object: "list", data: []))
    client.product_types.list
  end

  it "retrieves a product type" do
    stub_request(:get, "#{base_url}/m/product_types/pt_1")
      .to_return(**json_response(object: "product_type", id: "pt_1"))
    expect(client.product_types.retrieve("pt_1")["id"]).to eq("pt_1")
  end

  it "creates with the product_type: wrapper" do
    stub_request(:post, "#{base_url}/m/product_types")
      .with(body: { product_type: { name: "Channel" } })
      .to_return(**json_response(object: "product_type", id: "pt_1").merge(status: 201))
    client.product_types.create(name: "Channel")
  end

  it "updates with the product_type: wrapper" do
    stub_request(:patch, "#{base_url}/m/product_types/pt_1")
      .with(body: { product_type: { name: "Channel v2" } })
      .to_return(**json_response(object: "product_type", id: "pt_1"))
    client.product_types.update("pt_1", name: "Channel v2")
  end

  it "deletes a product type" do
    stub_request(:delete, "#{base_url}/m/product_types/pt_1").to_return(status: 204, body: "")
    expect(client.product_types.delete("pt_1")).to be_nil
  end
end
