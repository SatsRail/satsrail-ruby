# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Webhooks do
  it "lists webhooks" do
    stub_request(:get, "#{base_url}/m/webhooks")
      .to_return(**json_response(object: "list", data: []))
    expect(client.webhooks.list["object"]).to eq("list")
  end

  it "creates a webhook" do
    stub_request(:post, "#{base_url}/m/webhooks")
      .with(body: { webhook: { url: "https://example.com", events: ["payment.received"] } })
      .to_return(**json_response(object: "webhook", id: "wh_1", secret_key: "whsec_abc").merge(status: 201))

    result = client.webhooks.create(url: "https://example.com", events: ["payment.received"])
    expect(result["secret_key"]).to eq("whsec_abc")
  end

  it "retrieves a webhook" do
    stub_request(:get, "#{base_url}/m/webhooks/wh_1")
      .to_return(**json_response(object: "webhook", id: "wh_1"))
    expect(client.webhooks.retrieve("wh_1")["id"]).to eq("wh_1")
  end

  it "updates a webhook" do
    stub_request(:patch, "#{base_url}/m/webhooks/wh_1")
      .with(body: { webhook: { active: false } })
      .to_return(**json_response(object: "webhook", id: "wh_1", active: false))
    client.webhooks.update("wh_1", active: false)
  end

  it "deletes a webhook" do
    stub_request(:delete, "#{base_url}/m/webhooks/wh_1").to_return(status: 204, body: "")
    expect(client.webhooks.delete("wh_1")).to be_nil
  end
end
