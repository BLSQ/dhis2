# frozen_string_literal: true

require "test_helper"

class EventAndProgramTest < Minitest::Test
  def test_create_events_with_some_conflicts
    tuples = [
      {
        program:     "eBAyeGv0exc",
        org_unit:    "DiszpKrYNg8",
        event_date:  "2017-03-10",
        data_values: [
          { data_element: "qrur9Dvnyt5", value: "11233345" },
          { data_element: "oZg33kd9taw", value: "Male" }
        ]
      },
      {
        program:     "eBAyeGv0exc",
        org_unit:    "DiszpKrYNg8",
        event_date:  "2017-03-11",
        data_values: [
          { data_element: "qrur9Dvnyt5", value: "654987123" },
          { data_element: "oZg33kd9", value: "" }
        ]
      }
    ]
    status = Dhis2.client.events.create(tuples)
    assert_equal nil, status.import_summaries[0].conflicts
    assert_equal [{ "object" => "dataElement", "value" => "oZg33kd9 is not a valid data element" }], status.import_summaries[1].conflicts
  end

  def test_find_program
    assert_equal "Inpatient morbidity and mortality", Dhis2.client.programs.find("eBAyeGv0exc").name
  end

  def test_should_find_events
    events = Dhis2.client.events.list(program: "eBAyeGv0exc")
    event = events.first
    refute_nil(event.id)
    assert_equal(event.id, event.event)
  end
end
