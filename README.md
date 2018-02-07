# Dhis2

<a href="https://codeclimate.com/github/BLSQ/dhis2"><img src="https://codeclimate.com/github/BLSQ/dhis2/badges/gpa.svg" /></a>
[![Gem Version](https://badge.fury.io/rb/dhis2.svg)](https://badge.fury.io/rb/dhis2)
[![Build Status](https://travis-ci.org/BLSQ/dhis2.svg?branch=master)](https://travis-ci.org/BLSQ/dhis2)
[![Test Coverage](https://codeclimate.com/github/BLSQ/dhis2/badges/coverage.svg)](https://codeclimate.com/github/BLSQ/dhis2/coverage)

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
  config.url      = "https://play.dhis2.org/2.28"
  config.user     = "admin"
  config.password = "district"
  config.version  = "2.28"
end
::Dhis2.client.data_elements.list # => Array[<DataElement>,..]

# Or alternatively
::Dhis2.configure do |config|
  url:     "https://admin:district@play.dhis2.org/2.28",
  version: "2.28"
)
::Dhis2.clientt.data_elements.list # => Array[<DataElement>,..]
```

* Local configuration: (in case you need to access different Dhis2 instances inside a single project):

```ruby
configuration = Dhis2::Configuration.new.tap do |config|
  config.url      = "https://play.dhis2.org/2.28"
  config.user     = "admin"
  config.password = "district"
  config.version  = "2.28"
end
client = ::Dhis2::Client.new(configuration.client_params)
client.data_elements.list # => Array[<DataElement>,..]

# Or alternatively
client = ::Dhis2::Client.new(
  url:     "https://admin:district@play.dhis2.org/2.28",
  version: "2.28"
)
client.data_elements.list # => Array[<DataElement>,..]
```

Regarding SSL, there is an option to disregard SSL error messages (such as bad certificates). USE THIS AT YOUR OWN RISK - it may allow you to access a server that would return in error without it... but you cannot trust the response.

```ruby
dangerous_configuration = Dhis2::Configuration.new.tap do |config|
  config.url      = "https://play.dhis2.org/2.28"
  config.user     = "admin"
  config.password = "district"
  config.version  = "2.28"
  config.no_ssl_verification = true
end
```

### Search for meta elements

All subsequent calls can be done on the objects themselves and are going to use the provided url and credentials

```ruby
org_unit_levels = Dhis2.client.organisation_unit_levels.list
```

The various methods are taking an optional hash parameter to be used for ´filter´ and ´fields´ values:

```ruby
org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: %w(id level displayName parent))
```

If you want all fields, simply specify `:all`

```ruby
org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: :all)
```

Notes that any field found in the resulting JSON will be accessible from the object.

### Raw data

By default, the gem transforms data from the api so you get underscore case. But this may not be needed and can hurt performance.

If you simply need raw data from your Dhis2:

```ruby
org_units = Dhis2.client.organisation_units.list({}, true)
```

### Pagination

Following the DHIS2 API, all calls are paginated - you can access the page info using the `pager` property on the returned list:

```ruby
org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: %w(id level displayName parent))
org_units.pager.page       # current page
org_units.pager.page_count # number of pages
org_units.pager.total      # number of records
```

### Get all paginated elements

It can be tedious to iterate over a paginated collection. Thus you can use `fetch_paginated_data` which will get all pages for you and yield each element automatically.

```ruby
Dhis2.client.organisation_units.fetch_paginated_data(
  filter: "level:eq:2",
  fields: %w(id level displayName parent)
).each do |organisation_unit|
  # do what you need here
end
```

### Retrieve a single element

You can also retreive a single element using its id with `find`(in this case, all fields are returned by default):

```ruby
ou = Dhis2.client.organisation_units.find(id)
```

`find` also accepts multiple ids - query will not be paginated and will return all fields for the given objects:

```ruby
ous = Dhis2.client.organisation_units.find([id1, id2, id3])
```

If you have an equality condition or set of equality conditions that should return a single element, you can use `find_by` instead of the longer list option:

```ruby
# Instead of this:
data_element = Dhis2.client.data_elements.list(filter: "code:eq:C27", fields: :all).first

# Just do:
data_element = Dhis2.client.data_elements.find_by(code: "C27")
```

### Manage relations

You can add or remove items in collections using `add_relation` and `remove_relation`:

```ruby
data_set = Dhis2.client.data_sets.list(page_size:1).first
data_element = Dhis2.client.data_elements.list(page_size: 1).first
data_set.add_relation(:dataSetElements, data_element.id)
...
data_set.remove_relation(:dataSetElements, data_element.id)
```

### Values

You can retreive data values this way:

```ruby
ds                = Dhis2.client.data_sets.find_by(name: "Child Health")
organisation_unit = Dhis2.client.organisation_units.find_by(name: "Baoma")
period            = "201512"
value_sets        = Dhis2.client.data_value_sets.list(
  data_sets: [ds.id],
  organisation_unit: organisation_unit.id, periods: [period]
)
```

## Supported items

The API is currently limited to actions on the following elements:

* `OrganisationUnit`
* `OrganisationUnitGroup`
* `OrganisationUnitLevel`
* `DataElement`
* `DataSet`
* `DataValueSet`
* `DataValue`
* `Analytic`
* `CategoryCombo`
* `CategoryOptionCombo`
* `SystemInfo`
* `Attribute`
* `Indicator`
* `IndicatorGroup`
* `DataElementGroup`
* `User`
* `Report`
* `ReportTable`
* `Program`
* `Events`
* `ResourceTables`

## Update

### Full update

You can update a given item by retreiving it using its id, making any modification on it then calling "update":

```ruby
org_unit = Dhis2.client.organisation_units.find(id)
org_unit.short_name = "New Short Name"
org_unit.update
```

This uses DHIS2 "full update" ('PUT') and not the "partial update" feature (see below), so it requires a fully formed object to work (get it either with `find` which takes all the fields or with the `fields: :all´ option).

### Partial update

You can update a single or more attributes via the "update_attributes" method:

```ruby
org_unit         = Dhis2.client.organisation_units.list(fields: :all, filter: "name:eq:#{org_unit_name}").first
new_attributes   = { name: "New name" }
org_unit.update_attributes(new_attributes)
```

Note that partial updates will no work with custom attributes at this time (while the full update will)

## Create

A very basic **write** use case exists for `DataElement`:

```ruby
data_element = Dhis2.client.data_elements.create({
  name: "TesTesT1",
  short_name: "TTT1"
})
```

We do validate arguments and the response status. `Dhis2::CreationError` exception is raised in case of error.

### Bulk create

Whenever you need to create many elements at the same time, you can use `bulk_create`:

```ruby
elements = [
  { name: "TesTesT1", short_name: "TTT1" },
  { name: "TesTesT2", short_name: "TTT2" }
]
summary = Dhis2.client.data_elements.bulk_create(elements)
# would raise Dhis2::CreationError on error
summary.imported_count # => 1
summary.updated_count  # => 1
summary.ignored_count  # => 0
```

### Raw input

You might have data in camel case already and need to use it as is. In this case, we do not validate your input and do not create an object out of the response. Yet we validate the object has been properly created and return the plain response from the API.

```ruby
response = Dhis2.client.data_elements.create({
  name: "TesTesT1",
  shortName: "TTT1"
}, true)

summary = Dhis2.client.data_elements.bulk_create([{
  name: "TesTesT1",
  shortName: "TTT1"
}], true)
```

## Trigger analytics

You can trigger Analytics with

Dhis2.client.resource_tables.analytics

## Raw output

To get raw data from Dhis2, ie no underscore case, no object, just plain json, you can specify you want the raw output:

```ruby
client.data_elements.list({}, true)
#returns a PaginatedArray which elements look like:
{"id"=>"FTRrcoaog83", "displayName"=>"Accute Flaccid Paralysis (Deaths < 5 yrs)"}

client.data_elements.fetch_paginated_data({}, true) do |data_element|
  # use data_element as hash
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake test` and `bundle exec rspec` to run the tests. Note that the tests are using the DHIS2 demo server, which is reset every day but can be updated by anyone - so if someone change the password of the default user, the tests are going to fail.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/BLSQ/dhis2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
