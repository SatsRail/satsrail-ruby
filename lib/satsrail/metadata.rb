# frozen_string_literal: true

module SatsRail
  # Mirror of portal/app/models/concerns/has_metadata.rb:
  #   - max 50 keys
  #   - max 40-char keys
  #   - max 500-char string values
  #   - all values stored as strings
  #
  # Catching violations here gives the caller a clean ArgumentError instead of
  # a 422 round-trip.
  module Metadata
    MAX_KEYS = 50
    MAX_KEY_LENGTH = 40
    MAX_VALUE_LENGTH = 500

    module_function

    def validate!(metadata)
      return if metadata.nil?

      raise ArgumentError, "metadata must be a Hash" unless metadata.is_a?(Hash)
      if metadata.size > MAX_KEYS
        raise ArgumentError, "metadata supports at most #{MAX_KEYS} key-value pairs (got #{metadata.size})"
      end

      metadata.each do |key, value|
        k = key.to_s
        if k.length > MAX_KEY_LENGTH
          raise ArgumentError, "metadata key #{k.inspect} exceeds #{MAX_KEY_LENGTH} characters"
        end

        v = value.to_s
        if v.length > MAX_VALUE_LENGTH
          raise ArgumentError, "metadata value for #{k.inspect} exceeds #{MAX_VALUE_LENGTH} characters"
        end
      end
    end
  end
end
