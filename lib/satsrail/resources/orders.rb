# frozen_string_literal: true

module SatsRail
  module Resources
    class Orders < BaseResource
      def list(**params)
        list_request(params)
      end

      def create(**params)
        order_keys = %i[total_amount_cents currency items metadata]
        order_body = params.select { |k, _| order_keys.include?(k) }
        top_keys = %i[generate_invoice payment_method]
        top_body = params.select { |k, _| top_keys.include?(k) }
        create_request({ order: order_body }.merge(top_body))
      end

      def retrieve(id, **params)
        retrieve_request(id, params)
      end

      def update(id, **params)
        update_request(id, { order: params })
      end

      def delete(id)
        delete_request(id)
      end

      private

      def resource_path
        "/orders"
      end
    end
  end
end
