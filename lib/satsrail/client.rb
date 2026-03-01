# frozen_string_literal: true

module SatsRail
  class Client
    attr_reader :orders, :invoices, :payments, :payment_requests,
                :wallets, :checkout_sessions, :webhooks, :merchant,
                :catalog, :subscription_plans

    def initialize(api_key: nil, base_url: nil, timeout: nil)
      config = SatsRail.configuration
      key = api_key || config.api_key
      raise AuthenticationError.new("API key is required") unless key

      http = HttpClient.new(
        api_key: key,
        base_url: base_url || config.base_url,
        timeout: timeout || config.timeout
      )

      @orders = Resources::Orders.new(http)
      @invoices = Resources::Invoices.new(http)
      @payments = Resources::Payments.new(http)
      @payment_requests = Resources::PaymentRequests.new(http)
      @wallets = Resources::Wallets.new(http)
      @checkout_sessions = Resources::CheckoutSessions.new(http)
      @webhooks = Resources::Webhooks.new(http)
      @merchant = Resources::Merchant.new(http)
      @catalog = Resources::Catalog.new(http)
      @subscription_plans = Resources::SubscriptionPlans.new(http)
    end
  end
end
