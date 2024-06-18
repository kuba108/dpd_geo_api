# frozen_string_literal: true

module DpdGeoApi
  class Response
    attr_reader :http_status, :body, :errors

    def initialize(http_status, body = nil)
      @errors = []
      @http_status = http_status
      # Tries to parse body, which should be JSON
      # when http status is 2xx or 4xx kind and not 404 - page not found.
      return unless (200..299).include?(@http_status) || ((400..499).include?(@http_status))

      @body = parse_body(body)
    end

    def response_code
      @body["code"] if @body.present?
    end

    def response_message
      @body["message"] if @body.present?
    end

    def response_description
      @body["description"] if @body.present?
    end

    def valid?
      (200..299).include?(@http_status)
    end

    private

    def parse_body(body)
      JSON.parse(body)
    rescue StandardError
      { error: "JSON parse error!" }
    end
  end
end
