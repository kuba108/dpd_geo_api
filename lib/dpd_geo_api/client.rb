# frozen_string_literal: true

module DpdGeoApi
  class Client
    attr_reader :api_secret, :api_url, :request_maker

    def initialize(api_secret, api_url = "https://geoapi.dpd.cz/v1")
      @api_secret = api_secret
      @api_url = api_url[-1] == "/" ? api_url[0..-2] : api_url
    end

    # GET request /me
    # Use this method to get information about your customers and customer addresses.
    # User account which is used to find the data is determined by an API key provided in a request header.
    def me
      @request_maker = DpdGeoApi::RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/me")
    end

    # GET request /parcels
    # Use this for getting the list of all parcels associated with any of the customers under this user account.
    # Returns everything that was created in a selected time-frame by the current user account.
    # The goal is to provide an overview of every parcel via a single endpoint.
    def parcels
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/parcels")
    end

    # POST request /parcels/labels
    # Same as the POST /parcels/{parcelIdent}/labels endpoint but for batched printing.
    # A single ZPL/EPL script will contain instructions for printing multiple labels.
    # The PDF will contain one or multiple pages with all labels.
    def parcels_batch_labels(json)
      raise "Invalid parcel labels JSON." if json.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.post_request("/parcels/labels", json)
    end

    # POST request /parcels/{parcel_id}/labels
    # The parcel can have multiple labels, so an array is always returned.
    # The script/PDF always contains only single label.
    def parcels_labels(parcel_id, json)
      raise "Invalid parcel labels JSON." if json.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.post_request("/parcels/#{parcel_id}/labels", json)
    end

    # POST request /parcels/tracking
    # Same as the GET /parcels/{parcelNo}/tracking endpoint but for batched tracking information.
    def parcels_batch_tracking(json)
      raise "Invalid parcel tracking JSON." if json.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.post_request("/parcels/tracking", json)
    end

    # GET request /parcels/{parcel_id}/tracking
    # The identification of the parcel in question.
    # The value will be interpreted as a parcel number by default.
    # If you want to provide a GeoAPI ID then provide the input with the 'id-' prefix (e.g. id-23479).
    # You can do this with the parcel number too using the 'no-' prefix (e.b. no-12345678901234)
    def parcels_tracking(parcel_id)
      raise "Invalid parcel ID." if parcel_id.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/parcels/#{parcel_id}/tracking")
    end

    # POST request /pickup-orders
    # You can create pickup orders via this endpoint.
    # A pickup order is a request for a courier to come and pick your parcels up.
    # The courier will then proceed to forward the parcels into further transit and make sure they will eventually reach their shipping destination.
    def create_pickup_order(json)
      raise "Invalid pickup order JSON." if json.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.post_request("/pickup-orders", json)
    end

    # DELETE request /pickup-orders
    def delete_pickup_order(pickup_order_id)
      raise "Invalid pickup order ID." if pickup_order_id.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.delete_request("/pickup-orders/#{pickup_order_id}")
    end

    def get_pickup_order(pickup_order_id)
      raise "Invalid pickup order ID." if pickup_order_id.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/pickup-orders/#{pickup_order_id}")
    end

    # GET request /shipping-services
    # List of available shipping services.
    def shipping_services
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/shipping-services")
    end

    # GET request /countries
    # List of available countries.
    def countries
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/countries")
    end

    # GET request /customers
    # List of customers.
    # Each user account has multiple customers associated with it.
    # Each customer has its own DSW and his own customer addresses.
    def customers
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/customers")
    end

    # GET request /customers/{customer_dsw}
    # Get customer by DSW.
    # You can use these customer addresses when creating a new shipment or pickup order.
    # If the customer is not associated with your account, an error will be returned.
    def get_customer(customer_dsw)
      raise "Invalid customer DSW." if customer_dsw.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.get_request("/customers/#{customer_dsw}")
    end

    # POST request /shipments
    # Use this endpoint to create new parcel shipments.
    # Shipments consist of one or more parcels.
    #
    # Info:
    # It is strongly recommended to batch the shipments into bigger requests.
    # Sending many small requests at once can cause performance degradation.
    # GeoApi handles maximum of 50 shipments in one request.
    #
    # In case you have incorporated a mistake into the shipment data,
    # just create a new shipment with corrected data.
    # You can then throw away the printed labels and use new ones.
    def create_shipment(json)
      raise "Invalid shipment JSON." if json.blank?
      @request_maker = RequestMaker.new(@api_secret, @api_url)
      @request_maker.post_request("/shipments", json)
    end
  end
end
