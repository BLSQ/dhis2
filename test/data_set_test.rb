require "test_helper"

class DataSetTest < Minitest::Test
  def test_list_data_sets
    data_sets = Dhis2::DataSet.list(page_size: 10)
    assert_equal 10, data_sets.size
    data_set = data_sets.first

    assert_equal Dhis2::DataSet, data_set.class
    refute_nil data_set.id
    refute_nil data_set.displayName
  end

  def test_create_data_sets
    sets = [
      { name: "TesTesT1", short_name: "TTT1" },
      { name: "TesTesT2", short_name: "TTT2" }
    ]
    status = Dhis2::DataSet.create(sets)
    assert_equal true, status.success?
    assert_equal 2, status.total_imported
  end

  def test_create_data_sets_with_links
    org_units = Dhis2::OrganisationUnit.list(page_size: 2)
    data_elements = Dhis2::DataElement.list(page_size: 2)
    sets = [
      {
        name:                  "FullTestT",
        short_name:            "FTT",
        code:                  "FTT",
        organisation_unit_ids: org_units.map(&:id),
        data_element_ids:      data_elements.map(&:id)
      }
    ]
    status = Dhis2::DataSet.create(sets)
    assert_equal true, status.success?
    assert_equal 1, status.total_imported

    id = status.last_imported_ids.first

    created_set = Dhis2::DataSet.find(id)

    refute_empty created_set.dataElements
    refute_empty created_set.organisationUnits
  end
end
