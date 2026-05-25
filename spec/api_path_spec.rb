# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::ApiPath do
  describe ".m" do
    it "prefixes /m" do
      expect(described_class.m("/orders")).to eq("/m/orders")
      expect(described_class.m("/orders/ord_1")).to eq("/m/orders/ord_1")
    end
  end

  describe ".pub" do
    it "prefixes /pub" do
      expect(described_class.pub("/subscription_plans")).to eq("/pub/subscription_plans")
    end
  end
end
