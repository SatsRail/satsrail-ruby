# frozen_string_literal: true

require "spec_helper"

RSpec.describe SatsRail::Metadata do
  describe ".validate!" do
    it "accepts nil" do
      expect { described_class.validate!(nil) }.not_to raise_error
    end

    it "accepts a small valid hash" do
      expect { described_class.validate!(order_id: "ord_1", source: "web") }.not_to raise_error
    end

    it "rejects non-hash input" do
      expect { described_class.validate!("nope") }.to raise_error(ArgumentError, /must be a Hash/)
    end

    it "rejects more than 50 keys" do
      payload = (1..51).each_with_object({}) { |i, h| h[:"k#{i}"] = "v" }
      expect { described_class.validate!(payload) }.to raise_error(ArgumentError, /at most 50/)
    end

    it "rejects a key longer than 40 chars" do
      payload = { ("k" * 41).to_sym => "v" }
      expect { described_class.validate!(payload) }.to raise_error(ArgumentError, /exceeds 40 characters/)
    end

    it "rejects a value longer than 500 chars" do
      payload = { ok: "v" * 501 }
      expect { described_class.validate!(payload) }.to raise_error(ArgumentError, /exceeds 500 characters/)
    end

    it "stringifies value lengths so numbers pass" do
      expect { described_class.validate!(count: 12_345) }.not_to raise_error
    end
  end
end
