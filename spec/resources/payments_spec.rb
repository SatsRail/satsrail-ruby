# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Payments do
  it "lists payments" do
    stub_request(:get, "#{base_url}/m/payments")
      .to_return(**json_response(object: "list", data: []))
    expect(client.payments.list["object"]).to eq("list")
  end

  it "retrieves a payment" do
    stub_request(:get, "#{base_url}/m/payments/pay_1")
      .to_return(**json_response(object: "payment", id: "pay_1"))
    expect(client.payments.retrieve("pay_1")["id"]).to eq("pay_1")
  end
end
