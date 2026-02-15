# frozen_string_literal: true

module SatsRail
  module Resources
    class PaymentRequests < BaseResource
      def create(**params)
        create_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def status(id)
        @http.get("#{resource_path}/#{id}/status")
      end

      private

      def resource_path
        "/payment_requests"
      end
    end
  end
end
