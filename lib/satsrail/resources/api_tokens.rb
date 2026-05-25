# frozen_string_literal: true

module SatsRail
  module Resources
    class ApiTokens < BaseResource
      # Get API token usage statistics (secret tokens only). Returns a hash
      # with rpm_limit, monthly_request_count, current_rpm.
      def usage(id)
        @http.get("#{resource_path}/#{id}/usage")
      end

      private

      def resource_path
        ApiPath.m("/api_tokens")
      end
    end
  end
end
