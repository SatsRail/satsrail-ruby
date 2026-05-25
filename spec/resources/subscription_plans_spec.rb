# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Resources::SubscriptionPlans do
  it "lists plans against the public namespace" do
    stub_request(:get, "#{base_url}/pub/subscription_plans")
      .to_return(**json_response(object: "list", data: []))
    client.subscription_plans.list
  end
end
