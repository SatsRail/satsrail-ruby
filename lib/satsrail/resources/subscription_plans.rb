# frozen_string_literal: true

module SatsRail
  module Resources
    class SubscriptionPlans < BaseResource
      def list(**params)
        list_request(params)
      end

      private

      def resource_path
        "/subscription_plans"
      end
    end
  end
end
