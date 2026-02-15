# frozen_string_literal: true

require_relative "satsrail/configuration"
require_relative "satsrail/errors"
require_relative "satsrail/http_client"
require_relative "satsrail/resources/base_resource"
require_relative "satsrail/resources/orders"
require_relative "satsrail/resources/invoices"
require_relative "satsrail/resources/payments"
require_relative "satsrail/resources/payment_requests"
require_relative "satsrail/resources/wallets"
require_relative "satsrail/resources/checkout_sessions"
require_relative "satsrail/resources/webhooks"
require_relative "satsrail/resources/merchant"
require_relative "satsrail/client"

module SatsRail
  VERSION = "0.1.0"

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
