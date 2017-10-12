# frozen_string_literal: true
require "test_helper"

class ReportTableTest < Minitest::Test
  def test_get_report_table
    report_tables = Dhis2.client.report_tables.list(fields: %w(id displayName), page_size: 1)
    assert_equal 1, report_tables.size

    report_table = Dhis2.client.report_tables.find(report_tables.first.id)

    refute_nil report_table.display_name
    refute_nil report_table.id
  end
end
