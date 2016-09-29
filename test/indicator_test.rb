require "test_helper"

class IndicatorTest < Minitest::Test

  def test_get_indicator
    indicators = Dhis2.client.indicators.list(fields: %w(id displayName code), page_size: 1)
    assert_equal 1, indicators.size

    indicator = Dhis2.client.indicators.find(indicators.first.id)

    refute_nil indicator.display_name
    refute_nil indicator.id
    refute_nil indicator.short_name
  end
end
