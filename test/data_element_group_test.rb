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
    groups = [
      { name: "group_one", short_name: "groutp_one" },
      { name: "group_two", short_name: "gtwo" }
    ]

    status = Dhis2.client.data_element_groups.create(groups)

    assert_equal true, status.success?
    assert_equal 2, status.total_imported
  end

  def test_get_data_element_group
    data_element_groups = Dhis2.client.data_element_groups.list(fields: %w(id displayName code), page_size: 1)
    assert_equal 1, data_element_groups.size

    data_element_group = Dhis2.client.data_element_groups.find(data_element_groups.first.id)

    refute_nil data_element_group.display_name
    refute_nil data_element_group.id
  end
end
