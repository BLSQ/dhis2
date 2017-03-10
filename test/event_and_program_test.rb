# frozen_string_literal: true
require "test_helper"

class EventAndProgramTest < Minitest::Test
  def test_create_events
    tuples = [
      {
        program:     "eBAyeGv0exc",
        org_unit:    "DiszpKrYNg8",
        event_date:  "2017-03-10",
        data_values: [
          { data_element: "qrur9Dvnyt5", value: "11233345" },
          { data_element: "oZg33kd9taw", value: "Male" }
        ]
      }
    ]
    status = Dhis2.client.events.create(tuples)
    assert_equal true, status.success?
  end

  def test_find_program
    assert_equal "Inpatient morbidity and mortality", Dhis2.client.programs.find("eBAyeGv0exc").name
  end
end
