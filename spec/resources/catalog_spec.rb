# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Catalog do
  it "retrieves the catalog" do
    stub_request(:get, "#{base_url}/m/catalog")
      .to_return(**json_response(object: "catalog", products: []))
    expect(client.catalog.retrieve["object"]).to eq("catalog")
  end

  it "retrieves the catalog version" do
    stub_request(:get, "#{base_url}/m/catalog/version")
      .to_return(**json_response(version: "v1"))
    expect(client.catalog.version["version"]).to eq("v1")
  end
end
