require "test_helper"

class AttributeTest < Minitest::Test
  def test_list_attibutes
    attributes = Dhis2.client.attributes.list
    assert_equal 9, attributes.size

    first_attribute = attributes.first

    assert_equal "DnrLSdo4hMl", first_attribute.id
    assert_equal "Alternative name", first_attribute.display_name
  end

end
