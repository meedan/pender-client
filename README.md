
# PenderClient

This gem is a client for pender, which defines itself as 'A parsing and rendering service'. It also provides mock methods to test it.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pender_client'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pender_client

## Usage

With this gem you can call methods from pender's API and also test them by using the provided mocks.

The available methods are:

* PenderClient::Request.get_medias (`GET /api/medias`)
* PenderClient::Request.delete_medias (`DELETE /api/medias`)

If you are going to test something that uses the 'pender_client' service, first you need to mock each possible response it can return, which are:

* PenderClient::Mock.mock_medias_returns_parsed_data
* PenderClient::Mock.mock_medias_returns_url_not_provided
* PenderClient::Mock.mock_medias_returns_access_denied
* PenderClient::Mock.mock_medias_returns_timeout
* PenderClient::Mock.mock_medias_returns_api_limit_reached
* PenderClient::Mock.mock_delete_medias_returns_access_denied
* PenderClient::Mock.mock_delete_medias_returns_success

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
      
