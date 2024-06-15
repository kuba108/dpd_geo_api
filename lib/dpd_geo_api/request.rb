# frozen_string_literal: true

module DpdGeoApi
  class Request

    attr_accessor :method, :url, :headers, :body

    def initialize(method, url, headers, body)
      @method = method
      @url = url
      @headers = headers
      @body = body
    end

  end
end
