# frozen_string_literal: true

module DpdGeoApi
  class RequestMaker

    def initialize(api_user, api_secret)
      @api_user = api_user
      @api_secret = api_secret
    end

    def get
      raise "Method not implemented"
    end

    def post(url, body = nil)
      request = Request.new(:post, url, build_header, body.to_json)
      connection = create_connection(url, request.headers)
      raw_response = connection.post do |req|
        req.body = request.body
      end
      response = build_response(raw_response)
      if response.valid?
        {
          result: 'success',
          response: response,
          response_status: response.response_status,
          msg: "All packages was accepted by Balikobot."
        }
      else
        response.parse_errors
        {
          result: 'error',
          response: response,
          response_status: response.response_status,
          errors: response.errors,
          msg: "Response from Balikobot was not successful."
        }
      end
    end

    def delete
      raise "Method not implemented"
    end

    def put
      raise "Method not implemented"
    end

    private

    # Builds HTTP header.
    def build_header
      {
        'Authorization': "Basic #{Base64.encode64("#{@api_user}:#{@api_secret}")}",
        'Content-Type': 'application/json'
      }
    end

    # Creates connection by Faraday
    def create_connection(url, headers)
      Faraday.new(url: url, headers: headers) do |conn|
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
