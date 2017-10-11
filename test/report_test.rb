# frozen_string_literal: true
require "test_helper"

class ReportTest < Minitest::Test
  def test_get_report
    reports = Dhis2.client.reports.list(fields: %w(id displayName reportTable), page_size: 1)
    assert_equal 1, reports.size

    report = Dhis2.client.reports.find(reports.first.id)

    refute_nil report.display_name
    refute_nil report.id
    refute_nil report.report_table
    refute_nil report.design_content
  end
end
