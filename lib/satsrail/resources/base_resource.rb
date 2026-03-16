# frozen_string_literal: true

module SatsRail
  module Resources
    class BaseResource
      def initialize(http)
        @http = http
      end

      private

      def resource_path
        raise NotImplementedError
      end

      def list_request(params = {})
        @http.get(resource_path, params)
      end

      def create_request(body = {})
        @http.post(resource_path, body)
      end

      def retrieve_request(id, params = {})
        @http.get("#{resource_path}/#{id}", params)
      end

      def update_request(id, body = {})
        @http.patch("#{resource_path}/#{id}", body)
      end

      def delete_request(id)
        @http.delete("#{resource_path}/#{id}")
      end
    end
  end
end
