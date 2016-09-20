# Dhis2

<a href="https://codeclimate.com/github/BLSQ/dhis2"><img src="https://codeclimate.com/github/BLSQ/dhis2/badges/gpa.svg" /></a>

Basic DHIS2 API client for Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dhis2' # get it from RubyGems
gem 'dhis2', github: 'BLSQ/dhis2' # OR get the bleeding edge version from github
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dhis2

## Usage

### Connection

The functionalities are available as a module. First thing you need to do is to connect to the instance:

* Global configuration (to call a single Dhis2 instance):

  ```ruby 
  Dhis2.configure do |config|
      config.url      = "https://play.dhis2.org/demo"
      config.user     = "admin"
      config.password = "district"
  end
  Dhis2.client.data_elements.list # => Array[<DataElement>,..]
  ```

* Local configuration: (in case you need to access different Dhis2 instances inside a single project):
  
  ```ruby 
  client = Dhis2::Client.new(url: "https://play.dhis2.org/demo", user: "admin", password: "district")
  client.data_elements.list # => Array[<DataElement>,..]
  ```

### Search for meta elements

All subsequent calls can be done on the objects themselves and are going to use the provided url and credentials

    org_unit_levels = Dhis2.client.organisation_unit_levels.list

The various methods are taking an optional hash parameter to be used for ´filter´ and ´fields´ values:

    org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: %w(id level displayName parent))

If you want all fields, simply specify `:all`

    org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: :all)

Notes that any field found in the resulting JSON will be accessible from the object.

### Pagination

Following the DHIS2 API, all calls are paginated - you can access the page info using the `pager` property on the returned list:

    org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: %w(id level displayName parent))
    org_units.pager.page       # current page
    org_units.pager.page_count # number of pages 
    org_units.pager.total      # number of records

### Retreive a single element

You can also retreive a single element using its id with `find`(in this case, all fields are returned by default):

    ou = Dhis2.client.organisation_units.find(id)

`find` also accepts multiple ids - query will not be paginated and will return all fields for the given objects:

    ous = Dhis2.client.organisation_units.find([id1, id2, id3])

If you have an equality condition or set of equality conditions that should return a single element, you can use `find_by` instead of the longer list option:

    # Instead of this:
    data_element = Dhis2.client.data_elements.list(filter: "code:eq:C27", fields: :all).first

    # Just do:
    data_element = Dhis2.client.data_elements.find_by(code: "C27")

### Values

You can retreive data values this way:

    ds                = Dhis2.client.data_sets.find_by(name: "Child Health")
    organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma")
    period            = "201512"
    value_sets        = Dhis2.client.data_value_sets.list(
      data_sets: [ds.id], 
      organisation_unit: organisation_unit.id, periods: [period]
    )

## Supported features

The API is currently limited to **read** actions on the following elements/classes:

* `OrganisationUnit`
* `OrganisationUnitLevels`
* `DataElement`
* `DataSet`
* `CategoryCombo`

A very basic **write** use case exists for `DataElement` and `DataSet`:

    elements = [
      { name: "TesTesT1", short_name: "TTT1" },
      { name: "TesTesT2", short_name: "TTT2" }
    ]
    status = Dhis2.client.data_elements.create(elements)
    status.success? # => true
    status.total_imported # => 2

DHIS2 API does not return the ids of the created elements, but you can retreive them with their (unique) name or code.

    elements = [
      { name: "TesTesT2", short_name: "TTT2" }
    ]
    status = Dhis2.client.data_elements.create(elements)
    element = Dhis2.client.data_elements.find_by(name: "TesTesT2")

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. Note that the tests are using the DHIS2 demo server, which is reset every day but can be updated by anyone - so if someone change the password of the default user, the tests are going to fail.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/dhis2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
