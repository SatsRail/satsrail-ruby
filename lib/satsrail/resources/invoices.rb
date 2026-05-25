# frozen_string_literal: true

module SatsRail
  module Resources
    class Invoices < BaseResource
      # POST /m/invoices/generate — issues a Lightning/on-chain invoice for an
      # existing order. Body takes order_id and optional payment_method +
      # required_confirmations (on-chain only).
      def generate(order_id:, payment_method: nil, required_confirmations: nil, idempotency_key: nil)
        body = { order_id: order_id }
        body[:payment_method] = payment_method if payment_method
        body[:required_confirmations] = required_confirmations if required_confirmations
        @http.post(
          "#{resource_path}/generate",
          body,
          headers: HttpClient.idempotency_headers(idempotency_key)
        )
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def status(id)
        @http.get("#{resource_path}/#{id}/status")
      end

      # Returns the invoice QR code as SVG (string).
      def qr(id)
        @http.get("#{resource_path}/#{id}/qr")
      end

      private

      def resource_path
        ApiPath.m("/invoices")
      end
    end
  end
end
