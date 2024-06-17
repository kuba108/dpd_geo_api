# frozen_string_literal: true

module DpdGeoApi
  class RequestMaker

    attr_reader :api_secret, :api_url, :connection, :request, :raw_response, :response

    def initialize(api_secret, api_url)
      @api_secret = api_secret
      @api_url = api_url
      @connection = nil
      @request = nil
      @raw_response = nil
      @response = nil
    end

    def get_request(url)
      @request = Request.new(:get, "#{@api_url}/#{url}", build_header)
      @connection = create_connection(url, @request.headers)
      @connection.get
    end

    def post_request(url, body = nil)
      @request = Request.new(:post, "#{@api_url}/#{url}", build_header, body.to_json)
      @connection = create_connection(url, @request.headers)
      @raw_response = @connection.post do |req|
        req.body = @request.body
      end
      @response = build_response(@raw_response)
      if @response.valid?
        {
          result: "success",
          response: @response,
          response_status: @response.response_status,
          msg: "All packages was accepted by Balikobot."
        }
      else
        @response.parse_errors
        {
          result: "error",
          response: @response,
          response_status: @response.response_status,
          errors: @response.errors,
          msg: "Response from Balikobot was not successful."
        }
      end
    end

    def put_request
      raise "Method not implemented"
    end

    def delete_request(url)
      @request = Request.new(:delete, "#{@api_url}/#{url}", build_header)
      @connection = create_connection(url, @request.headers)
      @connection.delete
    end

    private

    # Builds HTTP header.
    def build_header
      {
        "x-api-key": @api_secret.to_s,
        "Content-Type": "application/json"
      }
    end

    # Creates connection by Faraday
    def create_connection(url, headers)
      Faraday.new(url:, headers:) do |conn|
        conn.request  :json
        conn.response :logger                  # log requests to STDOUT
        conn.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end

    # Creates request object.
    def build_response(raw_response, ignore_body = false)
      if ignore_body
        Response.new(raw_response.status)
      else
        Response.new(raw_response.status, raw_response.body)
      end
    end
  end
end
