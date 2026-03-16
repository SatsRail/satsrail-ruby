# frozen_string_literal: true

module SatsRail
  module Resources
    # Products resource — manage products and encryption keys.
    class Products < BaseResource
      # Get a product's encryption key (server-side only, requires sk_live_).
      #
      # @param id [String] Product ID
      # @return [Hash] Hash with :key field
      def get_key(id)
        @http.get("/m/products/#{id}/key")
      end

      # Trigger key rotation for a product.
      #
      # Generates a new encryption key and fires the product.key_rotated webhook.
      #
      # @param id [String] Product ID
      # @return [Hash] Hash with :old_key and :new_key fields
      def rotate_key(id)
        @http.post("/m/products/#{id}/rotate_key")
      end

      private

      def resource_path
        "/m/products"
      end
    end
  end
end
