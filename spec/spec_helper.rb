# frozen_string_literal: true

require "satsrail"
require "webmock/rspec"

module SpecHelpers
  BASE_URL = "https://app.satsrail.com/api/v1"
  API_KEY = "sk_test_abc123"

  def base_url
    BASE_URL
  end

  def api_key
    API_KEY
  end

  def client
    @client ||= SatsRail::Client.new(api_key: api_key)
  end

  def json_response(body)
    { headers: { "Content-Type" => "application/json" }, body: body.is_a?(String) ? body : body.to_json }
  end
end

RSpec.configure do |config|
  config.include SpecHelpers

  config.before(:each) do
    SatsRail.instance_variable_set(:@configuration, nil)
    @client = nil
  end
end
