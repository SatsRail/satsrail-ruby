# frozen_string_literal: true

module SatsRail
  module Resources
    class Orders < BaseResource
      # Keys that sit at the top of the request body, not inside `order: {...}`.
      # These are request-level flags rather than order attributes.
      TOP_LEVEL_KEYS = %i[generate_invoice payment_method mark_as_paid required_confirmations].freeze

      def list(**params)
        list_request(params)
      end

      def create(idempotency_key: nil, **params)
        Metadata.validate!(params[:metadata]) if params.key?(:metadata)
        top, attrs = params.partition { |k, _| TOP_LEVEL_KEYS.include?(k) }.map(&:to_h)
        body = { order: attrs }.merge(top)
        @http.post(resource_path, body, headers: HttpClient.idempotency_headers(idempotency_key))
      end

      def retrieve(id, **params)
        retrieve_request(id, params)
      end

      def update(id, **params)
        Metadata.validate!(params[:metadata]) if params.key?(:metadata)
        update_request(id, { order: params })
      end

      def delete(id)
        delete_request(id)
      end

      alias cancel delete

      private

      def resource_path
        ApiPath.m("/orders")
      end
    end
  end
end
