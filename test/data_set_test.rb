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
end
