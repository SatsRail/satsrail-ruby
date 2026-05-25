# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Merchant do
  it "retrieves the authenticated merchant" do
    stub_request(:get, "#{base_url}/m/merchant")
      .to_return(**json_response(object: "merchant", id: "mer_1"))
    expect(client.merchant.retrieve["id"]).to eq("mer_1")
  end
end
