# frozen_string_literal: true

module SatsRail
  module Resources
    class Catalog < BaseResource
      def retrieve
        @http.get("/catalog")
      end

      def version
        @http.get("/catalog/version")
      end
    end
  end
end
