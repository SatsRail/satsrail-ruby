# frozen_string_literal: true

module SatsRail
  VERSION = "0.2.0"
end

require_relative "satsrail/configuration"
require_relative "satsrail/api_path"
require_relative "satsrail/metadata"
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
require_relative "satsrail/resources/merchant_documents"
require_relative "satsrail/resources/catalog"
require_relative "satsrail/resources/subscription_plans"
require_relative "satsrail/resources/products"
require_relative "satsrail/resources/product_types"
require_relative "satsrail/resources/api_tokens"
require_relative "satsrail/resources/access"
require_relative "satsrail/client"

module SatsRail
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
