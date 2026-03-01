# frozen_string_literal: true

module SatsRail
  module Resources
    class PaymentRequests < BaseResource
      def create(**params)
        idempotency_key = params.delete(:idempotency_key)
        headers = idempotency_key ? { "Idempotency-Key" => idempotency_key } : {}
        @http.post(resource_path, { payment_request: params }, headers: headers)
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
