# frozen_string_literal: true

module SatsRail
  module Resources
    class ProductTypes < BaseResource
      def list(**params)
        list_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def create(**params)
        create_request({ product_type: params })
      end

      def update(id, **params)
        update_request(id, { product_type: params })
      end

      def delete(id)
        delete_request(id)
      end

      private

      def resource_path
        ApiPath.m("/product_types")
      end
    end
  end
end
