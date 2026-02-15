# frozen_string_literal: true

module SatsRail
  module Resources
    class Payments < BaseResource
      def list(**params)
        list_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      private

      def resource_path
        "/payments"
      end
    end
  end
end
