# frozen_string_literal: true
require "test_helper"

class AttributeTest < Minitest::Test

  DATA_SET_DHIS_ID = "VTdjfLXXmoi"
  ORGANISATION_UNIT_DHIS_ID = "vxa2YQRGV7I"
  PERIODS = ["201701","201702","201703"]

  def fetch_registrations
    Dhis2.play(true).complete_data_set_registrations.list(
        periods: PERIODS,
        organisation_units: [ORGANISATION_UNIT_DHIS_ID],
        data_sets: [DATA_SET_DHIS_ID]
    )
  end

  def delete_registrations(registrations)
    registrations.each do |reg|
        Dhis2.play(true).complete_data_set_registrations.delete(
            period: reg.period,
            data_set: reg.data_set,
            organisation_unit: reg.organisation_unit
        )         
    end
  end

  def test_list_open_close_complete_data_set_registration

    delete_registrations(fetch_registrations)
    assert_equal(fetch_registrations.count, 0)

    PERIODS.each do |period|
        created = Dhis2.play(true).complete_data_set_registrations.create(
            period: period,
            organisation_unit: ORGANISATION_UNIT_DHIS_ID,
            data_set: DATA_SET_DHIS_ID
        )
    end

    cdr = fetch_registrations
    assert_equal(cdr.count, PERIODS.count)
    
    delete_registrations(cdr)
    assert_equal(fetch_registrations.count, 0)
  end

end
