# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module SatsRail
  class HttpClient
    def initialize(api_key:, base_url:, timeout:)
      @api_key = api_key
      @base_url = base_url.chomp("/")
      @timeout = timeout
    end

    def get(path, params = {})
      uri = build_uri(path, params)
      request = Net::HTTP::Get.new(uri)
      execute(uri, request)
    end

    def post(path, body = {})
      uri = build_uri(path)
      request = Net::HTTP::Post.new(uri)
      request.body = JSON.generate(body)
      request["Content-Type"] = "application/json"
      execute(uri, request)
    end

    def patch(path, body = {})
      uri = build_uri(path)
      request = Net::HTTP::Patch.new(uri)
      request.body = JSON.generate(body)
      request["Content-Type"] = "application/json"
      execute(uri, request)
    end

    def delete(path)
      uri = build_uri(path)
      request = Net::HTTP::Delete.new(uri)
      execute(uri, request)
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
      body = response.body && !response.body.empty? ? JSON.parse(response.body) : nil

      if status >= 200 && status < 300
        body
      else
        raise Error.from_response(status, body || {})
      end
    rescue JSON::ParserError
      raise Error.new("Invalid JSON response", status: status)
    end
  end
end
