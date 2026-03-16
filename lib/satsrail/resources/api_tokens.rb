# frozen_string_literal: true

module SatsRail
  module Resources
    # API Tokens resource — manage API token usage and rate limits.
    class ApiTokens < BaseResource
      # Get API token usage statistics (secret tokens only).
      #
      # @param id [String] API Token ID
      # @return [Hash] Hash with :rpm_limit, :monthly_request_count, and :current_rpm fields
      def usage(id)
        @http.get("/m/api_tokens/#{id}/usage")
      end

      private

      def resource_path
        "/m/api_tokens"
      end
    end
  end
end
