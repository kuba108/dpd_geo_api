# frozen_string_literal: true

module DpdGeoApi
  class Response
    attr_reader :http_status, :body, :errors

    def initialize(http_status, body = nil)
      @errors = []
      @http_status = http_status
      # Tries to parse body, which should be JSON
      # when http status is 2xx or 4xx kind and not 404 - page not found.
      return unless (200..299).include?(@http_status) || ((400..499).include?(@http_status) && @http_status != 404)

      @body = parse_body(body)
    end

    def response_status
      @body["status"].to_i if @body.present?
    end

    def response_message
      @body["messages"] if @body.present?
    end

    def valid?
      (200..299).include?(response_status)
    end

    def parse_errors
      @errors = ResponseValidator.new.validate_response(self)
    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue StandardError
      ""
    end
  end
end
