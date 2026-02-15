# frozen_string_literal: true

module SatsRail
  class Error < StandardError
    attr_reader :status, :code, :details, :request_id

    def initialize(message = nil, status: nil, code: nil, details: nil, request_id: nil)
      @status = status
      @code = code
      @details = details
      @request_id = request_id
      super(message)
    end

    def self.from_response(status, body)
      error = body.is_a?(Hash) ? (body["error"] || body) : {}
      message = error["message"] || "API error (#{status})"
      attrs = {
        status: status,
        code: error["code"],
        details: error["details"],
        request_id: error["request_id"]
      }

      klass = case status
              when 401 then AuthenticationError
              when 404 then NotFoundError
              when 422 then ValidationError
              when 429 then RateLimitError
              else Error
              end
      klass.new(message, **attrs)
    end
  end

  class AuthenticationError < Error; end
  class ValidationError < Error; end
  class NotFoundError < Error; end
  class RateLimitError < Error; end
end
