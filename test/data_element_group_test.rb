# frozen_string_literal: true
require "test_helper"

class DataElementGroupTest < Minitest::Test
  def test_list_data_element_groups
    data_element_groups = Dhis2.client.data_element_groups.list(fields: %w(id displayShortName displayName code), page_size: 1)
    assert_equal 1, data_element_groups.size

    data_element_group = data_element_groups.first

    refute_nil data_element_group.display_name
    refute_nil data_element_group.id
  end

  def test_create_data_element_groups
    random = Random.new
    one = random.rand(10_000)
    two = random.rand(10_000)
    groups = [
      { name: "group_one_#{one}", short_name: "group_one_#{one}" },
      { name: "group_two_#{two}", short_name: "gtwo_#{two}" }
    ]

    status = Dhis2.client.data_element_groups.create(groups)

    assert_equal true, status.success?
    assert_equal 2, status.total_imported
  end

  def test_create_data_element_groups_with_data_elements
    random = Random.new
    one = random.rand(10_000)
    two = random.rand(10_000)
    groups = [
      { name: "group_one_#{one}", short_name: "group_one_#{one}" },
      { name: "group_two_#{two}", short_name: "gtwo_#{two}",
          data_elements: [
            { id: "HLPuaFB7Frw" }
          ] }
    ]

    status = Dhis2.client.data_element_groups.create(groups)

    assert_equal true, status.success?
    assert_equal 2, status.total_imported

    data_element_groups = Dhis2.client.data_element_groups.list(
      fields: "id,displayName,code,dataElements",
      page_size: 1,
      filter: "name:eq:#{groups[1][:name]}"
    )
    assert_equal data_element_groups.first[:data_elements], [{"id"=>"HLPuaFB7Frw"}]
  end

  def test_get_data_element_group
    data_element_groups = Dhis2.client.data_element_groups.list(fields: %w(id displayName code), page_size: 1)
    assert_equal 1, data_element_groups.size

    data_element_group = Dhis2.client.data_element_groups.find(data_element_groups.first.id)

    refute_nil data_element_group.display_name
    refute_nil data_element_group.id
  end
end
