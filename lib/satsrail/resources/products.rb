# frozen_string_literal: true

module SatsRail
  module Resources
    # Products live under /m/products. Identifiers accept both UUID and slug
    # (portal's product lookup falls back to slug when id_param doesn't match).
    class Products < BaseResource
      def list(**params)
        list_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def create(**params)
        Metadata.validate!(params[:metadata]) if params.key?(:metadata)
        create_request({ product: params })
      end

      def update(id, **params)
        Metadata.validate!(params[:metadata]) if params.key?(:metadata)
        update_request(id, { product: params })
      end

      def delete(id)
        delete_request(id)
      end

      # Returns the current encryption key for a product. sk_live_ only.
      def get_key(id)
        @http.get("#{resource_path}/#{id}/key")
      end

      # Generates a new encryption key and fires product.key_rotated. The
      # previous key is retained as old_key so in-flight clients can finish
      # decryption before clear_old_key.
      def rotate_key(id)
        @http.post("#{resource_path}/#{id}/rotate_key")
      end

      # Discards the previous key. Call after every client has rotated to the
      # new key returned by rotate_key.
      def clear_old_key(id)
        @http.post("#{resource_path}/#{id}/clear_old_key")
      end

      private

      def resource_path
        ApiPath.m("/products")
      end
    end
  end
end
