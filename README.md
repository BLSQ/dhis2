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

If you want all fields, simply specify ´:all´

    org_units = Dhis2.org_units(filter: "level:eq:2", fields: :all)

Notes that any field found in the resulting JSON will be accessible from the object.

Following the DHIS2 API, all calls are paginated - you can access the page info using the `pager` property on the returned list:

    org_units = Dhis2.org_units(filter: "level:eq:2", fields: %w(id level displayName parent))
    org_units.pager.page       # current page
    org_units.pager.page_count # number of pages 
    org_units.pager.total      # number of records

You can also retreive a single element (in this case, all fields are returned by default):

    ou = Dhis2.org_unit(id)

## Supported features

The API is currently limited to **read only** actions on the following elements:

* Organisation Units
* Organisation Units Levels
* Data Elements

A very basic **write** use case exists for Data Elements:

    elements = [
          { name: "TesTesT1", short_name: "TTT1" },
          { name: "TesTesT2", short_name: "TTT2" }
        ]
    status = Dhis2.create_data_elements(elements)
    status.success? # => true
    status.total_imported # => 2

DHIS2 API does not return the ids of the created elements, but you can retreive them with their (unique) name.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. Note that the tests are using the DHIS2 demo server, which is reset every day but can be updated by anyone - so if someone change the password of the default user, the tests are going to fail.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/dhis2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

