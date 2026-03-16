# frozen_string_literal: true

module SatsRail
  class Configuration
    attr_accessor :api_key, :base_url, :timeout

    def initialize
      @api_key = nil
      @base_url = "https://app.satsrail.com/api/v1"
      @timeout = 30
    end
  end
end
