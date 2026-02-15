# frozen_string_literal: true

module SatsRail
  module Resources
    class Invoices < BaseResource
      def generate(**params)
        order_id = params.delete(:order_id)
        payment_method = params.delete(:payment_method)
        body = { payment_method: payment_method }.compact.merge(params)
        @http.post("/orders/#{order_id}/invoices", body)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def status(id)
        @http.get("#{resource_path}/#{id}/status")
      end

      def qr(id)
        @http.get("#{resource_path}/#{id}/qr")
      end

      private

      def resource_path
        "/invoices"
      end
    end
  end
end
