# frozen_string_literal: true

module SatsRail
  module Resources
    class Merchant < BaseResource
      def retrieve
        @http.get("/merchant")
      end

      def list_orders(**params)
        @http.get("/merchant/orders", params)
      end

      def list_payments(**params)
        @http.get("/merchant/payments", params)
      end
    end
  end
end
