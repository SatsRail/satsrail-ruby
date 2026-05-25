# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module SatsRail
  class HttpClient
    SVG_CONTENT_TYPE = "image/svg+xml"

    def self.idempotency_headers(key)
      key ? { "Idempotency-Key" => key.to_s } : {}
    end

    def initialize(api_key:, base_url:, timeout:)
      @api_key = api_key
      @base_url = base_url.chomp("/")
      @timeout = timeout
    end

    def get(path, params = {})
      uri = build_uri(path, params)
      execute(uri, Net::HTTP::Get.new(uri))
    end

    def post(path, body = {}, headers: {})
      uri = build_uri(path)
      request = Net::HTTP::Post.new(uri)
      request.body = JSON.generate(body)
      request["Content-Type"] = "application/json"
      headers.each { |k, v| request[k] = v }
      execute(uri, request)
    end

    def patch(path, body = {}, headers: {})
      uri = build_uri(path)
      request = Net::HTTP::Patch.new(uri)
      request.body = JSON.generate(body)
      request["Content-Type"] = "application/json"
      headers.each { |k, v| request[k] = v }
      execute(uri, request)
    end

    def delete(path)
      uri = build_uri(path)
      execute(uri, Net::HTTP::Delete.new(uri))
    end

    private

    def build_uri(path, params = {})
      uri = URI("#{@base_url}#{path}")
      uri.query = URI.encode_www_form(params) unless params.empty?
      uri
    end

    def execute(uri, request)
      request["Authorization"] = "Bearer #{@api_key}"
      request["Accept"] = "application/json"
      request["User-Agent"] = "satsrail-ruby/#{SatsRail::VERSION}"

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = @timeout
      http.read_timeout = @timeout

      response = http.request(request)
      handle_response(response)
    end

    def handle_response(response)
      status = response.code.to_i

      # 204 No Content — DELETE endpoints return this on success.
      return nil if status == 204

      content_type = response["Content-Type"].to_s
      body_text = response.body.to_s

      # QR endpoints return image/svg+xml. Return the raw SVG string so the
      # caller can stream it to a browser or write it to disk.
      if content_type.include?(SVG_CONTENT_TYPE)
        return body_text if status >= 200 && status < 300

        raise Error.new("HTTP #{status}", status: status)
      end

      body = body_text.empty? ? nil : parse_json(body_text, status)

      if status >= 200 && status < 300
        body
      else
        raise Error.from_response(status, body || {})
      end
    end

    def parse_json(text, status)
      JSON.parse(text)
    rescue JSON::ParserError
      raise Error.new("Invalid JSON response", status: status)
    end
  end
end
