# frozen_string_literal: true

module Dhis2
  class Versioned
    MAPPING = {
      "2.24" => "Version224",
      "2.25" => "Version225",
      "2.26" => "Version226",
      "2.27" => "Version227",
      "2.28" => "Version228"
    }.freeze

    def self.[](version)
      Object.const_get "Dhis2::Api::#{MAPPING[version]}::#{basename}"
    end

    def self.basename
      name.split("::").last
    end
  end

  class Analytic < Versioned; end
  class Attribute < Versioned; end
  class Category < Versioned; end
  class CategoryOption < Versioned; end
  class CategoryCombo < Versioned; end
  class CategoryOptionCombo < Versioned; end
  class CompleteDataSetRegistration < Versioned; end
  class DataElement < Versioned; end
  class DataElementGroup < Versioned; end
  class DataSet < Versioned; end
  class DataValueSet < Versioned; end
  class Event < Versioned; end
  class Indicator < Versioned; end
  class IndicatorGroup < Versioned; end
  class IndicatorType < Versioned; end
  class LegendSet < Versioned; end
  class OrganisationUnit < Versioned; end
  class OrganisationUnitGroup < Versioned; end
  class OrganisationUnitGroupSet < Versioned; end
  class OrganisationUnitLevel < Versioned; end
  class Program < Versioned; end
  class Report < Versioned; end
  class ReportTable < Versioned; end
  class ResourceTable < Versioned; end
  class SystemInfo < Versioned; end
  class User < Versioned; end
end