# frozen_string_literal: true

module SatsRail
  class Client
    attr_reader :orders, :invoices, :payments, :payment_requests,
                :wallets, :checkout_sessions, :webhooks, :merchant,
                :merchant_documents, :catalog, :subscription_plans,
                :products, :product_types, :api_tokens, :access

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
      @merchant_documents = Resources::MerchantDocuments.new(http)
      @catalog = Resources::Catalog.new(http)
      @subscription_plans = Resources::SubscriptionPlans.new(http)
      @products = Resources::Products.new(http)
      @product_types = Resources::ProductTypes.new(http)
      @api_tokens = Resources::ApiTokens.new(http)
      @access = Resources::Access.new(http)
    end
  end
end
