# frozen_string_literal: true

module SatsRail
  module Resources
    class CheckoutSessions < BaseResource
      def create(**params)
        create_request({ checkout_session: params })
      end

      private

      def resource_path
        "/checkout_sessions"
      end
    end
  end
end
