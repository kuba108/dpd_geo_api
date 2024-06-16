# DpdGeoApi

Gem for interacting with the DPD Geo API.
API documentation is here [here](https://geoapi.dpd.cz/v2/swagger/).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add dpd_geo_api

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install dpd_geo_api

## Usage

This gem provides a simple interface to interact with the DPD Geo API. Here's a basic example of how to use it:

First, you need to initialize the `Client` with your API secret, API URL, and a boolean indicating whether to use the test API:

Main reason for this design with initialization of client is allow to use this gem for various DPD customers / clients with different API secrets and URLs.
I use that for multitenant warehouse management system WMS where each customer has its own DPD account and API secret.

```ruby
client = DpdGeoApi::Client.new('your_api_secret')
```

Or you can setup also URL and test mode:

```ruby
client = DpdGeoApi::Client.new('your_api_secret', 'https://geoapi.dpd.cz/v2', false)
```

Then you can use the client to make requests to the API:

```ruby
response = client.get('parcels', { parcel_number: '00000000000001' })
```

The response will be a `DpdGeoApi::Response` object, which has the following methods:
- `status`: The HTTP status code of the response
- `body`: The parsed JSON body of the response
- `headers`: The headers of the response
- `success?`: A boolean indicating whether the request was successful (status code 200)
- `error?`: A boolean indicating whether the request was unsuccessful (status code other than 200)
- `error_message`: The error message if the request was unsuccessful
- `error_code`: The error code if the request was unsuccessful
- `error_details`: The error details if the request was unsuccessful
- `error_response`: The full error response if the request was unsuccessful
- `error_response_body`: The parsed JSON body of the error response
- `error_response_headers`: The headers of the error response
- `error_response_status`: The HTTP status code of the error response
- `error_response_success?`: A boolean indicating whether the error response was successful (status code 200)
- `error_response_error?`: A boolean indicating whether the error response was unsuccessful (status code other than 200)
- `error_response_error_message`: The error message of the error response
- `error_response_error_code`: The error code of the error response
- `error_response_error_details`: The error details of the error response

I will provide more examples of API methods in the next section later.

### Client API methods

```ruby
# Get information about the authenticated user
response = client.me

# Get a list of parcels
parcels = client.parcels

# Get batch labels for a parcel
batch_labels = client.parcels_batch_labels('parcel_id')

# Get labels for a parcel
labels = client.parcels_labels('parcel_id', 'label_id')

# Track a parcel
tracking_info = client.parcels_tracking('parcel_id')

# Create a pickup order
pickup_order = client.create_pickup_order('order_details')

# Delete a pickup order
client.delete_pickup_order('order_id')

# Get a pickup order
pickup_order = client.get_pickup_order('order_id')

# Get a list of shipping services
shipping_services = client.shipping_services

# Get a list of countries
countries = client.countries

# Get a list of customers
customers = client.customers

# Get a customer
customer = client.get_customer('customer_id')

# Get shipments for a customer
shipments = client.shipments('customer_id')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dpd_geo_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dpd_geo_api/blob/main/CODE_OF_CONDUCT.md).

## Buy me a coffee

If this gem was helpful to you, feel free to buy me a coffee:

<a href="https://buymeacoffee.com/kuba108" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DpdGeoApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dpd_geo_api/blob/main/CODE_OF_CONDUCT.md).
