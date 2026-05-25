# frozen_string_literal: true

module SatsRail
  module Resources
    # Server-to-server access token verification. Content-delivery clients call
    # this with the macaroon they received from the customer to confirm payment
    # and retrieve the encryption key.
    #
    # Requires sk_live_ auth.
    class Access < BaseResource
      # Returns a hash with at least :valid and :remaining_seconds. For v2
      # macaroons with confirmed payment, also includes :product_id, :order_id,
      # :encryption_key, :key_fingerprint.
      def verify(access_token)
        @http.post(ApiPath.m("/access/verify"), { access_token: access_token })
      end
    end
  end
end
