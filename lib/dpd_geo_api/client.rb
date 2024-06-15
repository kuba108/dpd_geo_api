# frozen_string_literal: true

module DpdGeoApi
  class Client
    attr_reader :api_secret, :api_url, :test_api

    def initialize(api_secret, api_url, test_api: false)
      @api_secret = api_secret
      @api_url = api_url.last == "/" ? api_url[0..-2] : api_url
      @test_api = test_api
    end

    def me

    end
  end
end
