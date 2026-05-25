# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::Access do
  it "verifies a v2 macaroon and returns the encryption key" do
    stub_request(:post, "#{base_url}/m/access/verify")
      .with(body: { access_token: "macaroon_v2_abc" })
      .to_return(**json_response(
        valid: true,
        remaining_seconds: 3600,
        product_id: "pr_1",
        order_id: "ord_1",
        encryption_key: "k_abc",
        key_fingerprint: "fp_abc"
      ))

    result = client.access.verify("macaroon_v2_abc")
    expect(result["valid"]).to eq(true)
    expect(result["encryption_key"]).to eq("k_abc")
  end

  it "returns valid:false for an expired macaroon" do
    stub_request(:post, "#{base_url}/m/access/verify")
      .with(body: { access_token: "macaroon_expired" })
      .to_return(**json_response(valid: false, remaining_seconds: 0))

    expect(client.access.verify("macaroon_expired")["valid"]).to eq(false)
  end
end
