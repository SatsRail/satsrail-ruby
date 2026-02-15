# frozen_string_literal: true

module SatsRail
  module Resources
    class Wallets < BaseResource
      def list(**params)
        list_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      private

      def resource_path
        "/wallets"
      end
    end
  end
end
