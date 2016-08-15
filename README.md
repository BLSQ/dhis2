# Dhis2

Basic DHIS2 API client for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dhis2', :github => 'BLSQ/dhis2' # not published yet, so get it from github
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhis2

## Usage

The functionalities are available as a module. First thing you need to do is to connect to the instance:

    Dhis2.connect(url: "https://play.dhis2.org/demo", user: "admin", password: "district")

All subsequent calls are going to use the provided url and credentials

    org_unit_levels = Dhis2.org_unit_levels

The various methods are taking an optional hash parameter to be used for ´filter´ and ´fields´ values:

    org_units = Dhis2.org_units(filter: "level:eq:2", fields: %w(id level displayName parent))

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/dhis2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

