# BikeMfg

Bike brand and model information as a model, database migration, seed data, REST interface and more

[![Build Status](https://travis-ci.org/zflat/bike_mfg.svg?branch=master)](https://travis-ci.org/zflat/bike_mfg)

## Installation

Add this line to your application's Gemfile:

    gem 'bike_mfg'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bike_mfg

### Configuration

Run the generator:

	rails generate bike_mfg:install

Then migrate the database:

	rake db:migrate

Load the data into the database

	rake db:bike_mfg:seed

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Test it

      bundle exec rspec spec


