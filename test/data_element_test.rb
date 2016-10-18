require "test_helper"

class DataElementTest < Minitest::Test
  def test_list_data_elements
    data_elements = Dhis2.client.data_elements.list(fields: %w(id shortName displayName code), page_size: 1)
    assert_equal 1, data_elements.size

    data_element = data_elements.first

    refute_nil data_element.display_name
    refute_nil data_element.id
    refute_nil data_element.short_name
  end

  def test_create_data_elements
    elements = [
      { name: "TesTesT1", short_name: "TTT1" },
      { name: "TesTesT2", short_name: "TTT2" }
    ]
    status = Dhis2.client.data_elements.create(elements)
    assert_equal true, status.success?
    assert_equal 2, status.total_imported
  end

  def test_get_data_element
    data_elements = Dhis2.client.data_elements.list(fields: %w(id displayName code), page_size: 1)
    assert_equal 1, data_elements.size

    data_element = Dhis2.client.data_elements.find(data_elements.first.id)

    refute_nil data_element.display_name
    refute_nil data_element.id
    refute_nil data_element.short_name
  end

  def test_delete_data_element
    name = SecureRandom.hex
    element      = { name: name, short_name: SecureRandom.hex }
    status       = Dhis2.client.data_elements.create(element)
    data_element = Dhis2.client.data_elements.find_by(name: name)
    assert_equal true, data_element.delete
  end

end
