# frozen_string_literal: true

module SatsRail
  module Resources
    # Singular merchant resource — read-only access to the authenticated
    # merchant. Listing orders or payments goes through client.orders.list and
    # client.payments.list directly; there is no /merchant/orders endpoint.
    class Merchant < BaseResource
      def retrieve
        @http.get(ApiPath.m("/merchant"))
      end
    end
  end
end
