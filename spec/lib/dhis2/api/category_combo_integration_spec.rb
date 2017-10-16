# frozen_string_literal: true

require "spec_helper"

describe Dhis2::Api::CategoryCombo, type: :integration do
  describe "#create" do
    let(:client) { Dhis2.play(true, ENV.fetch("PLAY_PATH","release2")) }
    let(:unique_name) { "Posology #{rand(100_000)}" }

    def log_status(status)
      puts ""
      puts status.raw_status.to_json
      puts status.success?
      puts ""
      puts "**********************"
    end

    it "investigage status handling" do
      status = client.category_combos.create(
        name: unique_name
      )

      log_status(status)

      status = client.category_combos.create(
        name: unique_name
      )

      log_status(status)

      status = client.category_combos.create(
        name:       unique_name,
        short_name: "Posology short No #{rand(10_000)}"
      )

      log_status(status)

      status = client.category_combos.create(
        [
          { name: unique_name },
          { name: "Posology short No#{rand(10_000)}" }
        ]
      )

      expect(status).to eq("")
    end
  end
end
