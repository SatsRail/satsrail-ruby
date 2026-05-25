# frozen_string_literal: true

module SatsRail
  module Resources
    # Read-only view of merchant compliance documents.
    #
    # Uploads and deletions are admin-only operations and are intentionally not
    # exposed in this SDK — see docs/portal/compliance.md.
    class MerchantDocuments < BaseResource
      def list(**params)
        list_request(params)
      end

      def retrieve(id)
        retrieve_request(id)
      end

      private

      def resource_path
        ApiPath.m("/merchant_documents")
      end
    end
  end
end
