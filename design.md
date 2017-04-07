# Design

Some internal notes about the application - may be of interest to visitors also.

## Why a wrapper?

A HTTP request:

    response = Net::HTTP.get('https://play.dhis2.org/demo', '/api/organisationUnits?filter=name:eq:Baoma&fields=[id,name]')
    org_units = JSON.parse(response)

We need basic auth:

    uri = URI('https://play.dhis2.org/demo/api/organisationUnits?filter=name:eq:Baoma&fields=[id,name]')

    req = Net::HTTP::Get.new(uri)
    req.basic_auth 'user', 'pass'

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }
    puts res.body

We need to connect to various DHIS2 clients:

    project = Project.find(1)
    user = project.dhis2_user
    password = project.dhis2_password
    url = project.dhis2_url

    uri = URI("#{url}/api/organisationUnits?filter=name:eq:Baoma&fields=[id,name]")

    req = Net::HTTP::Get.new(uri)
    req.basic_auth user, password

    ...

and this all over the place

A bit better with Rest Client:

    response = RestClient.get 'https://play.dhis2.org/demo/api/organisationUnits', {params: {filter: "name:eq:Baoma", fields: '[id,name]'}}

But still:

- url all over the place
- user/passwords all over the place
- need to parse the JSON after (where is the data?)

vs:

    client = Dhis2::Client.new(user: "admin", password: "district", url: "https://play.dhis2.org/demo")
   
    # then:

    org_units = client.organisation_units.list
    org_units = client.organisation_units.list(fields: :all)

## Topics

### OpenStructs

OpenStruct: create an object with any fields you want from a Hash:

    s = OpenStruct.new
    s.name = "Van Aken"
    s.first_name = "Martin"
    s # name=Van Aken, first_name=Martin

Hash with object like syntax (nicer) - can be created from a Hash, so working very well with JSON:

    response = RestClient.get 'https://play.dhis2.org/demo/api/organisationUnits/123'
    raw = JSON.parse(response)
    ou = OpenStruct.new(raw) # got a nice object out of JSON

### Multi client

Initial API was very much ActiveRecord like:

    OrganisationUnit.find(id)
    DataElement.list(filter: "name:like:param")

we had to move to support multi clients:

    client.organisation_units.find(id)
    client.data_elements.list(filter: "name:like:param")

### Case conversion

Url is CamelCase, but this is not very ruby-ish:

   ous = client.organisationUnits
   puts ous.first.displayName

so we convert everything we get back to snake case.

### Status and error messages

We create a Status object able to answer to simple questions such as "was the call successful" - this is different depending on the DHIS2 version, and the usage of HTTP status code is not always consistent (it tend to return 200 even when a creation fail for instance).

### Version control

The Gem also help with the management of different versions of DHIS2, resolving some differences without impacting the end user.

## How it works:

   class Indicator < Base
   end

   report = client.indicators.find("xxx")
   puts report.name # "Deliveries coverage"

### A bit of meta programming for finders:

    class OrganisationUnit
      def self.find(id)
         execute("/organisationUnits/#{id}")
      end
    end

    class DataElement
      def self.find(id)
         execute("/dataElements/#{id}")
      end
    end

To:

    class Base
      def self.find(id)
        execute("#{resource_name}/#{id}")
      end
    end

    class DataElement < Base
      def self.resource_name
         "dataElements"
      end
    end

To:

    class Base
      def self.find(id)
        execute("#{resource_name}/#{id}")
      end

      def self.resource_name
        simple_name = name.split("::").last
        simple_name[0].downcase + simple_name[1..-1] + "s"
      end
    end

    class DataElement < Base
    end

### A bit of meta programming for objects

We want something such:

  client.organisation_units.find(id)
  client.data_elements.find(id)
  client.data_sets.find(id)
  ...

Again, those are just the "resource names" - no need to repeat ourselves.

We want

  client.data_sets.find(id)

to call the `find` method on the DataSet class.

We want one method on client for each class that inherit from Base:

Enter `inherited` - a method called each time a class inherit from this one:

    class Base
      def self.inherited(base)
        Dhis2::Client.register_resource(base)
      end
    end

We can use `define_method` to create a method for the given class (we underscore the name again as above):

    class Client
      def self.register_resource(resource_class)
        class_name  = resource_class.name.split("::").last
        method_name = underscore(class_name) + "s"
        define_method(method_name) do
          CollectionWrapper.new(resource_class, self)
        end
      end
    end

