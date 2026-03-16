# frozen_string_literal: true

module SatsRail
  module Resources
    class Webhooks < BaseResource
      def list(**params)
        list_request(params)
      end

      def create(**params)
        create_request({ webhook: params })
      end

      def retrieve(id)
        retrieve_request(id)
      end

      def update(id, **params)
        update_request(id, { webhook: params })
      end

      def delete(id)
        delete_request(id)
      end

      private

      def resource_path
        "/webhooks"
      end
    end
  end
end
