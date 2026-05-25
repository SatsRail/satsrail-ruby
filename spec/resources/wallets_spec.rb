# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Wallets do
  it "lists wallets" do
    stub_request(:get, "#{base_url}/m/wallets")
      .to_return(**json_response(object: "list", data: []))
    expect(client.wallets.list["object"]).to eq("list")
  end

  it "retrieves a wallet" do
    stub_request(:get, "#{base_url}/m/wallets/w_1")
      .to_return(**json_response(object: "wallet", id: "w_1"))
    expect(client.wallets.retrieve("w_1")["id"]).to eq("w_1")
  end
end
