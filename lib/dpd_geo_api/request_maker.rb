# frozen_string_literal: true

module DpdGeoApi
  class RequestMaker

    attr_reader :api_secret, :api_url, :connection, :request, :raw_response, :response

    def initialize(api_secret, api_url)
      @api_secret = api_secret
      @api_url = api_url
    end

    def get_request(url)
      @request = Request.new(:get, "#{@api_url}/#{url}", build_header, nil)
      @connection = create_connection(@request)
      @raw_response = @connection.get
      @response = build_response(@raw_response)
      build_response_json
    end

    def post_request(url, body = nil)
      @request = Request.new(:post, "#{@api_url}/#{url}", build_header, body.to_json)
      @connection = create_connection(@request)
      @raw_response = @connection.post do |req|
        req.body = @request.body
      end
      @response = build_response(@raw_response)
      build_response_json
    end

    def put_request
      raise "Method not implemented"
    end

    def delete_request(url)
      @request = Request.new(:delete, "#{@api_url}/#{url}", build_header, nil)
      @connection = create_connection(@request)
      @raw_response = @connection.delete
      @response = build_response(@raw_response)
      build_response_json
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
    def create_connection(request)
      Faraday.new(url: request.url, headers: request.headers) do |conn|
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

    # Builds response JSON.
    def build_response_json
      if @response.valid?
        {
          result: "success",
          response: @response,
          body: @response.body,
          message: @response.response_message,
          msg: "Request is accepted by DPD."
        }
      else
        {
          result: "error",
          response: @response,
          body: @response.body,
          code: @response.response_code,
          message: @response.response_message,
          description: @response.response_description,
          errors: @response.errors,
          msg: "Response from DPD was not successful."
        }
      end
    end
  end
end
