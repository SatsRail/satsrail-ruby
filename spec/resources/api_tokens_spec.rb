# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::ApiTokens do
  it "gets usage statistics" do
    stub_request(:get, "#{base_url}/m/api_tokens/tok_1/usage")
      .to_return(**json_response(rpm_limit: 60, current_rpm: 4, monthly_request_count: 1_234))
    result = client.api_tokens.usage("tok_1")
    expect(result["rpm_limit"]).to eq(60)
  end
end
