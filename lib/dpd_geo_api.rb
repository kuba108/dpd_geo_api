# frozen_string_literal: true

require_relative "dpd_geo_api/version"
require_relative "dpd_geo_api/client"
require_relative "dpd_geo_api/request"
require_relative "dpd_geo_api/request_maker"
require_relative "dpd_geo_api/response"
require_relative "dpd_geo_api/response_validator"

module DpdGeoApi
  class Error < StandardError; end
  # Your code goes here...
end
