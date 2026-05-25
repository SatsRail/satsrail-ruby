# frozen_string_literal: true

module SatsRail
  # The SatsRail API namespaces resources under /m/* (merchant, sk_*/pk_* auth)
  # and /pub/* (public/embed). Calls to the wrong namespace 404 silently — this
  # module keeps the distinction visible at every resource definition.
  module ApiPath
    module_function

    def m(suffix)
      "/m#{suffix}"
    end

    def pub(suffix)
      "/pub#{suffix}"
    end
  end
end
