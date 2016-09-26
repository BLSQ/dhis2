require "test_helper"

class DataSetTest < Minitest::Test
  def test_list_data_sets
    data_sets = Dhis2.client.data_sets.list(page_size: 10)
    assert_equal 10, data_sets.size
    data_set = data_sets.first

    assert_equal Dhis2::Api::DataSet, data_set.class
    refute_nil data_set.id
    refute_nil data_set.display_name
  end

  def test_create_data_sets
    sets = [
      { name: "TesTesT1", short_name: "TTT1", code: "TTT1" },
      { name: "TesTesT2", short_name: "TTT2", code: "TTT2"  }
    ]
    status = Dhis2.client.data_sets.create(sets)
    assert_equal true, status.success?
    assert_equal 2, status.total_imported

    data_set_1 = Dhis2.client.data_sets.list(fields: :all, filter: "code:eq:TTT1").first

    assert_equal "TTT1", data_set_1.code
    assert_equal "TTT1", data_set_1.short_name
  end

  def test_create_data_sets_with_links
    org_units     = Dhis2.client.organisation_units.list(page_size: 2)
    data_elements = Dhis2.client.data_elements.list(page_size: 2)
    sets          = [
      {
        name:                  "FullTestT",
        code:                  "FTT",
        short_name:            "FTT",
        data_element_ids:      data_elements.map(&:id),
        organisation_unit_ids: org_units.map(&:id)
      }
    ]
    status = Dhis2.client.data_sets.create(sets)
    assert_equal true, status.success?
    assert_equal 1, status.total_imported

    created_set = Dhis2.client.data_sets.find_by(code: "FTT")

    refute_empty created_set.data_elements
    refute_empty created_set.organisation_units
  end
end
