# frozen_string_literal: true

module DpdGeoApi
  class Client
    attr_reader :api_secret, :api_url, :test_api

    def initialize(api_secret, api_url: "https://geoapi-test.dpd.cz/v1/", test_api: false)
      @api_secret = api_secret
      @api_url = api_url.last == "/" ? api_url[0..-2] : api_url
      @test_api = test_api
    end

    # GET request /me
    # Use this method to get information about your customers and customer addresses.
    # User account which is used to find the data is determined by an API key provided in a request header.
    def me
      RequestMaker.new(@api_secret).get_request("#{@api_url}/me")
    end

    # GET request /parcels
    # Use this for getting the list of all parcels associated with any of the customers under this user account.
    # Returns everything that was created in a selected time-frame by the current user account.
    # The goal is to provide an overview of every parcel via a single endpoint.
    def parcels; end

    # GET request /parcels/{parcel_id}/labels
    # The parcel can have multiple labels, so an array is always returned.
    # The script/PDF always contains only single label.
    def parcels_labels(parcel_id, print_type: "ZPL", pageSize: "A4", labelsPerPage: 4, labelsOffset: 1)
      if print_type == "PDF"
        {
          printType: print_type,
          printProperties: {
            pageSize:,
            labelsPerPage:,
            labelsOffset:
          }
        }
      elsif print_type == "ZPL"
        {
          printType: print_type
        }
      else
        raise "Invalid print type. Must be either 'PDF' or 'ZPL'"
      end
    end

    # POST request /pickup-orders
    # You can create pickup orders via this endpoint.
    # A pickup order is a request for a courier to come and pick your parcels up.
    # The courier will then proceed to forward the parcels into further transit and make sure they will eventually reach their shipping destination.
    def pickup_orders; end
  end
end
