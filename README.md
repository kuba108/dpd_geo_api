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
client = DpdGeoApi::Client.new('your_api_secret', 'https://geoapi.dpd.cz/v2')
```

Then you can use the client to make first request to the API:

```ruby
response = client.me
```

It should return the information about the authenticated user.
Now you can make more advanced requests to the API:

```ruby
response = client.create_shipment(json)
```

JSON should reflect actual DPD documentation for the API.
However in Ruby we are using hash so my hash looks like this:

```ruby
def data
    data = {
      customer: {
        dsw: @client.dpd_customer_dsw
      },
      shipmentType: 'Standard',
      sender: {
        it4emId: @client.dpd_customer_address_id.to_i
      },
      receiver: {
        info: {
          name1: @package.company.present? ? @package.company : @package.name,
          contact: {
            person: @package.company.present? ? @package.company : @package.name,
            phone: get_phone,
            email: @package.valid_email? ? @package.email : ''
          },
        },
        address: {
          street: @package.street,
          postal_code: @package.zip,
          city: @package.city,
          country: {
            iso_alpha_2: @package.country_code
          }
        }
      },
      references: {
        ref1: @package.uniq_order_id
      },
      parcels: [],
      services: {
        notification: !@order.company_order? && @package.valid_phone?,
      }
    }

    # Pushes packages (parcels) to shipment
    @packages.each do |package|
      data[:parcels] << {
        references: {
          ref_1: package.uniq_order_id
        },
        weightGrams: package.weight == 0.0 ? 0 : package.weight * 1000
      }
    end

    if @package.cod_price > 0.0
      data[:services][:cash_on_delivery] = {
        amountCents: @package.cod_price.to_i * 100,
        payment: 'CashOrCard',
        variable_symbol: @package.order.number,
        currency: @package.currency
      }
    end

    data
  end
```

You method could be totally different, but the idea is to create a hash that will be converted to JSON and sent to the API.
Ruby uses snake_case and JSON camelCase so you need to convert it before sending it to the API.
This is my method to convert hash keys from snake_case to camelCase:

```ruby
class HashHelper
  def self.snake_to_camel(hash)
    hash.deep_transform_keys { |key| key.to_s.camelize(:lower) }.to_json
  end
end
```

Final step is to convert to JSON. I had problem with fact, that DPD accepts JSON as array.
So my solution is to put brackets around the JSON string:

```ruby
json = HashHelper.snake_to_camel(data)
result = client.create_shipment(JSON.parse("[#{json}]"))
```

Result is Hash with response from the API. In success case it should contain `status: 200`:

```ruby
{
  result: "success",
  response: DpdGeoApi::Response,
  body: DPD response,
  code: 200,
  message: "message",
  msg: "Request is accepted by DPD."
}
```

In case of error it should contain non 200 status code and error message:

```ruby
{
  result: "error",
  response: DpdGeoApi::Response,
  body: DPD response,
  code: 400,
  message: "message",
  description: "description",
  errors: [],
  msg: "Response from DPD was not successful."
}
```

I will provide more examples of API methods in the next section later.

### Client API methods

Fill in later.

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
