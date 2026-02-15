# frozen_string_literal: true

require "satsrail"
require "webmock/rspec"

RSpec.configure do |config|
  config.before(:each) do
    SatsRail.instance_variable_set(:@configuration, nil)
  end
end
