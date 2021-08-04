![Welcome](https://share.adam.ac/21/Artboard-Copy-otknRSsM6uRUMRrkCi.png)

This will provide an [Insomnia](https://insomnia.rest) compatible schema for a Apia API. It's a bit rough and ready at the moment and was put together quite quickly but it should generate what is needed of it. There are no tests.

You'll need to have your Apia API running. Once it's up and running, you can add this library.

## Installation

Start by adding the gem to your Gemfile.

```ruby
gem 'apia-insomnia', '~> 1.0'
```

Once you've done this, you'll need to just mount it up.

```
module MyApp
  class Application < Rails::Application

    # ... other configuration for your application will also be in this file.

    config.middleware.use Apia::Insomnia::Rack, 'CoreAPI::Base', '/api/core/v1/schema/insomnia',
      development: Rails.env.development?,
      base_url: "https://api.yourapp.com/v1"

  end
end
```

## Usage

You can then just access the appropriate URL above to download the schema. The URL can be pasted into
