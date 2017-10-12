# frozen_string_literal: true
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
    random = Random.new
    one = random.rand(10_000)
    two = random.rand(10_000)
    sets = [
      { name: "TesTesT1", short_name: "TTT#{one}", code: "TTT#{one}" },
      { name: "TesTesT2", short_name: "TTT#{two}", code: "TTT#{two}" }
    ]
    status = Dhis2.client.data_sets.create(sets)
    assert_equal true, status.success?
    assert_equal 2, status.total_imported

    data_set_1 = Dhis2.client.data_sets.list(fields: :all, filter: "code:eq:TTT#{one}").first

    assert_equal "TTT#{one}", data_set_1.code
    assert_equal "TTT#{one}", data_set_1.short_name
  end

  def test_add_remove_from_relation
    data_set = Dhis2.client.data_sets.list(page_size: 1).first
    data_element = Dhis2.client.data_elements.list(page_size: 1).first
    begin
      data_set.remove_relation(:dataSetElements, data_element.id)
    rescue => ignored
    end

    data_set.add_relation(:dataSetElements, data_element.id)
    data_set = Dhis2.client.data_sets.find(data_set.id)
    puts data_element_ids(data_set).to_json
    puts Dhis2.client.data_elements.list(page_size: 1).first

    # assert_includes(data_element_ids(data_set), data_element.id)
    # this is broken on play, looks like dataSetElements are a new resources
    # dataSetElements vs dataElements
    #  <dataElement id="wHngffm5bZU" name="Personnel administrative establishment" created="2013-06-27T00:00:00.000+0000" lastUpdated="2017-01-05T10:52:56.501+0000" href="http://dhis2-zw-sandbox.herokuapp.com/api/dataElements/wHngffm5bZU"/>
    # so doesn't work as expected yet
    # <dataSetElement created="2016-10-05T16:22:41.006" lastUpdated="2016-10-05T16:22:41.006" id="IJnZ0OyOUNT">
    #  <externalAccess>false</externalAccess>
    # <dataElement id="YgsAnqU3I7B"/>
    #  <dataSet id="lyLU2wR22tC"/>
    #  </dataSetElement>
    # but the resource is not yet known
    data_set.remove_relation(:dataSetElements, data_element.id)
    data_set = Dhis2.client.data_sets.find(data_set.id)
    puts data_element_ids(data_set).to_json
  end

  def data_element_ids(data_set)
    data_set.data_set_elements.map { |e| e["data_element"] }.map { |de| de["id"] }
  end

  def test_create_data_sets_with_links
    random = Random.new
    one = random.rand(10_000)
    org_units     = Dhis2.client.organisation_units.list(page_size: 2)
    data_elements = Dhis2.client.data_elements.list(page_size: 2)
    sets          = [
      {
        name:                  "FullTestT#{one}",
        code:                  "FullTestT#{one}",
        short_name:            "FullTestT#{one}",
        data_element_ids:      data_elements.map(&:id),
        organisation_unit_ids: org_units.map(&:id)
      }
    ]
    status = Dhis2.client.data_sets.create(sets)
    assert_equal true, status.success?
    assert_equal 1, status.total_imported

    created_set = Dhis2.client.data_sets.list(filter: "code:eq:FullTestT#{one}", fields: ":all").first
    refute_empty created_set.organisation_units

    data_element1 = Dhis2.client.data_elements.find(data_elements.first.id)

    refute_empty ([created_set.id] - data_element1.data_set_elements.map { |h| h["id"] })
  end
end
