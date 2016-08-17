require "dhis2/version"
require "rest-client"
require "json"
require "org_unit"
require "data_element"
require "org_unit_level"
require "status"
require "paginated_array"

module Dhis2
  class << self
    attr_reader :url

    def connect(options)
      raise "Missing #{url}" unless options[:url]
      raise "Missing #{user}" unless options[:user]
      raise "Missing #{password}" unless options[:password]

      @url = options[:url]
      @user = options[:user]
      @password = options[:password]
    end

    def org_units(options = {})
      response = get_resource("organisationUnits", options).get
      json_response = JSON.parse(response)
      PaginatedArray.new(json_response["organisationUnits"].map { |raw_org_unit| Dhis2::OrgUnit.new(raw_org_unit) }, json_response["pager"])
    end

    def data_elements(options = {})
      response = get_resource("dataElements", options).get
      json_response = JSON.parse(response)
      PaginatedArray.new(json_response["dataElements"].map { |raw_data_element| Dhis2::DataElement.new(raw_data_element) }, json_response["pager"])
    end

    def org_unit_levels
      response = get_resource("organisationUnitLevels", fields: %w(id name level)).get
      json_response = JSON.parse(response)
      PaginatedArray.new(
        json_response["organisationUnitLevels"].map { |raw_org_unit_level| Dhis2::OrgUnitLevel.new(raw_org_unit_level) }, 
        json_response["pager"]
      )
    end

    def org_unit(id)
      response = resource["organisationUnits/#{id}"].get
      json_response = JSON.parse(response)
      Dhis2::OrgUnit.new(json_response)
    end

    def data_element(id)
      response = resource["dataElements/#{id}"].get
      json_response = JSON.parse(response)
      Dhis2::DataElement.new(json_response)
    end

    def create_data_elements(elements)
      category_combo_id = JSON.parse(resource["categoryCombos"].get)["categoryCombos"].first["id"]
      data_element = {
        dataElements: elements.map do |element|
          {
            name: element[:name],
            shortName: element[:short_name],
            domainType: element[:domain_type] || "AGGREGATE",
            valueType: element[:value_type] || "INTEGER_POSITIVE",
            aggregationType: element[:aggregation_type] || "SUM",
            categoryCombo: { id: category_combo_id }
          }
        end
      }
      json_response = resource["metadata"].post(JSON.generate(data_element), content_type: "application/json")
      response = JSON.parse(json_response)

      Dhis2::Status.new(response)
    end

    private

    def resource
      @resource ||= RestClient::Resource.new("#{@url}/api", headers: { accept: "application/json" }, user: @user, password: @password)
    end

    def get_resource(name, options = {})
      arguments = []
      arguments << "fields=" + options[:fields].join(",") if options[:fields]
      arguments << "filter=" + options[:filter] if options[:filter]
      arguments << "pageSize=#{options[:page_size]}" if options[:page_size]
      arguments << "page=#{options[:page]}" if options[:page]

      path = "#{name}?#{arguments.join('&')}"
      resource[path]
    end
  end
end
