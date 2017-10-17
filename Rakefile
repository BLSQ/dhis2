# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task default: :test

# 2.24
VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE TIME INTEGER_NEGATIVE PERCENTAGE PHONE_NUMBER)
DATA_DIMENSION_TYPE = %w(ATTRIBUTE DISAGGREGATION)
AGGREGATION_TYPE = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)
DOMAIN_TYPE = %w(TRACKER AGGREGATE)
PROGRAM_TYPE = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)

# 2.25
VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE PHONE_NUMBER)
DATA_DIMENSION_TYPE = %w(ATTRIBUTE DISAGGREGATION)
AGGREGATION_TYPE = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)
DOMAIN_TYPE = %w(TRACKER AGGREGATE)
PROGRAM_TYPE = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)

# 2.26
VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE AGE PHONE_NUMBER)
DATA_DIMENSION_TYPE = %w(ATTRIBUTE DISAGGREGATION)
AGGREGATION_TYPE = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)
DOMAIN_TYPE = %w(TRACKER AGGREGATE)
PROGRAM_TYPE = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)

# # 2.27
VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE URL LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE AGE PHONE_NUMBER)
DATA_DIMENSION_TYPE = %w(ATTRIBUTE DISAGGREGATION)
AGGREGATION_TYPE = %w(DEFAULT, MAX, AVERAGE_INT_DISAGGREGATION, SUM, AVERAGE_BOOL, AVERAGE_INT, COUNT, CUSTOM, STDDEV, AVERAGE_SUM_ORG_UNIT, NONE, AVERAGE_SUM_INT, AVERAGE_SUM_INT_DISAGGREGATION, AVERAGE, VARIANCE, MIN)
DOMAIN_TYPE = %w(TRACKER AGGREGATE)
PROGRAM_TYPE = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)

# # 2.28
VALUE_TYPES = %w(UNIT_INTERVAL LETTER BOOLEAN NUMBER TEXT DATE URL LONG_TEXT FILE_RESOURCE USERNAME TRACKER_ASSOCIATE COORDINATE INTEGER_POSITIVE DATETIME EMAIL TRUE_ONLY INTEGER INTEGER_ZERO_OR_POSITIVE ORGANISATION_UNIT TIME INTEGER_NEGATIVE PERCENTAGE AGE PHONE_NUMBER)
DATA_DIMENSION_TYPE = %w(ATTRIBUTE DISAGGREGATION)
AGGREGATION_TYPE = %w(DEFAULT MAX AVERAGE_INT_DISAGGREGATION SUM AVERAGE_BOOL AVERAGE_INT COUNT CUSTOM STDDEV AVERAGE_SUM_ORG_UNIT NONE AVERAGE_SUM_INT AVERAGE_SUM_INT_DISAGGREGATION AVERAGE VARIANCE MIN)
DOMAIN_TYPE = %w(TRACKER AGGREGATE)
PROGRAM_TYPE = %w(WITHOUT_REGISTRATION WITH_REGISTRATION)



FEATURE_TYPE = %w(SYMBOL POLYGON MULTI_POLYGON NONE POINT)
PERIOD_TYPES = %w(Daily Weekly Monthly BiMonthly Quarterly SixMonthly Yearly)


END_POINTS = {
  "2.24" => {
    endpoints: {
      attributes: {
        fields: %w(name valueType)
      },
      categoryCombos: {
        fields: %w(name dataDimensionType)
      },
      categoryOptionCombos: {
        fields: %w(categoryCombo)
      },
      dataElements: {
        fields: %w(name aggregationType domainType categoryCombo valueType shortName)
      },
      dataElementGroups: {
        fields: %w(name)
      },
      dataSets: {
        fields: %w(name periodType)
      },
      indicatorTypes: {
        fields: %w(name)
      },
      indicators: {
        fields: %w(indicatorType numerator denominator name shortName)
      },
      organisationUnits: {
        fields: %w(openingDate name shortName)
      },
      organisationUnitGroups: {
        fields: %w(name)
      },
      organisationUnitGroupSets: {
        fields: %w(name)
      },
      organisationUnitLevels: {
        fields: %w(level name)
      },
      programs: {
        fields: %w(categoryCombo name programType)
      },
      reports: {
        fields: %w(name)
      },
      reportTables: {
        fields: %w(name)
      },
      users: {
        fields: %w(firstName surname)
      },
    },
    no_schema: {
      dataValues: {

      },
      dataValueSets: {

      },
      events: {

      },
      resourceTables: {

      }
    }
  },
  "2.25" => {
    endpoints: {
      attributes: {
        fields: %w(name valueType)
      },
      categoryCombos: {
        fields: %w(name dataDimensionType)
      },
      categoryOptionCombos: {
        fields: %w(categoryCombo)
      },
      dataElements: {
        fields: %w(aggregationType domainType categoryCombo valueType name shortName)
      },
      dataElementGroups: {
        fields: %w(name)
      },
      dataSets: {
        fields: %w(name periodType categoryCombo)
      },
      indicators: {
        fields: %w(indicatorType numerator denominator name shortName)
      },
      organisationUnits: {
        fields: %w(openingDate name shortName)
      },
      organisationUnitGroups: {
        fields: %w(name)
      },
      organisationUnitGroupSets: {
        fields: %w(name)
      },
      organisationUnitLevels: {
        fields: %w(level name)
      },
      programs: {
        fields: %w(categoryCombo name programType)
      },
      reports: {
        fields: %w(name)
      },
      reportTables: {
        fields: %w(name)
      },
      users: {
        fields: %w(firstName surname)
      },
    },
    no_schema: {
      dataValues: {

      },
      dataValueSets: {

      },
      events: {

      },
      resourceTables: {

      }
    }
  },
  "2.26" => {
    endpoints: {
      attributes: {
        fields: %w(name valueType)
      },
      categoryCombos: {
        fields: %w(name dataDimensionType)
      },
      dataElements: {
        fields: %w(aggregationType domainType valueType name shortName)
      },
      dataElementGroups: {
        fields: %w(name)
      },
      dataSets: {
        fields: %w(name periodType)
      },
      indicators: {
        fields: %w(indicatorType numerator denominator name shortName)
      },
      organisationUnits: {
        fields: %w(openingDate name shortName)
      },
      organisationUnitGroups: {
        fields: %w(name)
      },
      organisationUnitGroupSets: {
        fields: %w(name)
      },
      organisationUnitLevels: {
        fields: %w(level name)
      },
      programs: {
        fields: %w(shortName name programType)
      },
      reports: {
        fields: %w(name)
      },
      reportTables: {
        fields: %w(name)
      },
      users: {
        fields: %w(firstName surname)
      },
    },
    no_schema: {
      categoryOptionCombos: {
        error: "weird status not detailed"
      },
      dataValues: {

      },
      dataValueSets: {

      },
      events: {

      },
      resourceTables: {

      }
    }
  },
  "2.27" => {
    endpoints: {
      attributes: {
        fields: %w(name valueType)
      },
      categoryCombos: {
        fields: %w(name dataDimensionType)
      },
      dataElements: {
        fields: %w(aggregationType domainType valueType name shortName)
      },
      dataElementGroups: {
        fields: %w(name)
      },
      dataSets: {
        fields: %w(name periodType)
      },
      indicators: {
        fields: %w(indicatorType numerator denominator name shortName)
      },
      organisationUnits: {
        fields: %w(openingDate name shortName)
      },
      organisationUnitGroups: {
        fields: %w(name)
      },
      organisationUnitGroupSets: {
        fields: %w(name)
      },
      organisationUnitLevels: {
        fields: %w(level name)
      },
      programs: {
        fields: %w(shortName name programType)
      },
      reports: {
        fields: %w(name)
      },
      reportTables: {
        fields: %w(name)
      },
      users: {
        fields: %w(firstName surname)
      },
    },
    no_schema: {
      categoryOptionCombos: {
        error: "weird status not detailed"
      },
      dataValues: {

      },
      dataValueSets: {

      },
      events: {

      },
      resourceTables: {

      }
    }
  },
  "2.28" => {
    endpoints: {
      attributes: {
        fields: %w(name valueType)
      },
      categoryCombos: {
        fields: %w(name dataDimensionType)
      },
      dataElements: {
        fields: %w(aggregationType domainType valueType name shortName)
      },
      dataElementGroups: {
        fields: %w(name)
      },
      dataSets: {
        fields: %w(name periodType)
      },
      indicators: {
        fields: %w(indicatorType numerator denominator name shortName)
      },
      organisationUnits: {
        fields: %w(openingDate name shortName)
      },
      organisationUnitGroups: {
        fields: %w(name)
      },
      organisationUnitGroupSets: {
        fields: %w(name)
      },
      organisationUnitLevels: {
        fields: %w(level name)
      },
      programs: {
        fields: %w(shortName name programType)
      },
      reports: {
        fields: %w(name)
      },
      reportTables: {
        fields: %w(name)
      },
      users: {
        fields: %w(firstName surname)
      },
    },
    no_schema: {
      categoryOptionCombos: {
        error: "weird status not detailed"
      },
      dataValues: {

      },
      dataValueSets: {

      },
      events: {

      },
      resourceTables: {

      }
    }
  }
}
