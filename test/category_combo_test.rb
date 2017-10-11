# frozen_string_literal: true
require "test_helper"

class CategoryComboTest < Minitest::Test
  def test_list_combos
    combos = Dhis2.client.category_combos.list(fields: :all, page_size: 10)
    assert_equal 10, combos.size

    combo = combos.first

    refute_nil combo.name
    refute_nil combo.id
  end

  def test_get_default_combo
    default = Dhis2.client.category_combos.find_by(name: "default")
    refute_nil default

    assert_equal "default", default.name
  end
end
