# frozen_string_literal: true

module SatsRail
  module Resources
    class Catalog < BaseResource
      def retrieve
        @http.get(ApiPath.m("/catalog"))
      end

      def version
        @http.get(ApiPath.m("/catalog/version"))
      end
    end
  end
end
