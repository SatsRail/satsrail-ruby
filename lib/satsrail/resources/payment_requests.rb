# frozen_string_literal: true

module SatsRail
  module Resources
    class PaymentRequests < BaseResource
      def create(idempotency_key: nil, **params)
        Metadata.validate!(params[:metadata]) if params.key?(:metadata)
        @http.post(
          resource_path,
          { payment_request: params },
          headers: HttpClient.idempotency_headers(idempotency_key)
        )
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def status(id)
        @http.get("#{resource_path}/#{id}/status")
      end

      private

      def resource_path
        ApiPath.m("/payment_requests")
      end
    end
  end
end
