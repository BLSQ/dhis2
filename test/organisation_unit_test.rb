# frozen_string_literal: true
require "test_helper"
require "faker"
class OrganisationUnitTest < Minitest::Test
  def test_list_org_units
    org_units = Dhis2.client.organisation_units.list(fields: %w(parent children level id displayName))
    assert_equal 50, org_units.size
  end

  def test_update_org_unit
    org_units = Dhis2.client.organisation_units.list(fields: %w(id), page_size: 1)
    id        = org_units.first.id
    org_unit  = Dhis2.client.organisation_units.find(id)

    new_name = "Test New Name #{rand(100)}"
    org_unit.short_name = new_name

    org_unit.update

    ou = Dhis2.client.organisation_units.find(id)

    assert_equal new_name, ou.short_name
  end

  def test_find_org_unit
    org_units = Dhis2.client.organisation_units.list(fields: %w(id), page_size: 1)
    id        = org_units.first.id
    org_unit  = Dhis2.client.organisation_units.find(id)

    assert_equal id, org_unit.id
    refute_nil org_unit.level
    refute_nil org_unit.short_name
    refute_nil org_unit.last_updated
  end

  def test_find_org_units
    org_units_by_list = Dhis2.client.organisation_units.list(fields: %w(id), page_size: 9)
    ids               = org_units_by_list.map(&:id)
    org_units         = Dhis2.client.organisation_units.find(ids)

    assert_equal org_units_by_list.size, org_units.size

    org_units_by_list.each do |ou|
      assert org_units.include?(ou)
    end
  end

  def test_org_units_children
    org_unit_id             = Dhis2.client.organisation_units.find_by(name: "Bo").id
    org_units_with_children = Dhis2.client.organisation_units.find(org_unit_id, include_children: true)
    assert_equal 16, org_units_with_children.size
  end

  def test_org_units_descendants
    org_unit_id             = Dhis2.client.organisation_units.find_by(name: "Bo").id
    org_units_with_children = Dhis2.client.organisation_units.find(org_unit_id, include_descendants: true)

    assert_equal 141, org_units_with_children.pager.total

    assert_equal 125, org_units_with_children.select { |ou| ou.level == 4 }.size
  end

  def test_org_unit_last_level_descendants
    org_unit_id = Dhis2.client.organisation_units.find_by(name: "Bo").id
    org_units   = Dhis2.client.organisation_units.last_level_descendants(org_unit_id)
    assert_equal 125, org_units.size
    assert_equal [4], org_units.map(&:level).uniq
  end

  def test_list_org_units_all_fields
    org_units = Dhis2.client.organisation_units.list(fields: :all, page_size: 1)
    assert_equal 1, org_units.size
    org_unit = org_units.first

    refute_nil org_unit.level
    refute_nil org_unit.short_name
    refute_nil org_unit.last_updated
  end

  def test_list_org_units_pagination
    org_units = Dhis2.client.organisation_units.list(fields: %w(parent children level id displayName), page: 6)
    assert_equal 50, org_units.size
    refute_nil org_units.pager
    assert_equal 6, org_units.pager.page
  end

  def test_list_org_units_fields
    org_units = Dhis2.client.organisation_units.list(fields: %w(parent children level id code displayName), page_size: 1)

    assert_equal 1, org_units.size
    refute_nil org_units.first.code
  end

  def test_list_org_units_by_level
    org_units = Dhis2.client.organisation_units.list(filter: "level:eq:2", fields: %w(id level displayName parent))

    assert_equal 13, org_units.size

    org_units.each do |org_unit|
      assert_equal 2, org_unit.level
    end
  end

  def test_create_org_units
    org_unit_name_1 = SecureRandom.uuid
    org_unit_name_2 = SecureRandom.uuid
    random_id = Faker::Lorem.characters(11)
    org_units = [
      { name: org_unit_name_1, short_name: org_unit_name_1, opening_date: "2013-01-01", contact_person: "Zulumur Roland", phone_number: "57401156", email: "test@gmail.com", id: random_id },
      { name: org_unit_name_2, short_name: org_unit_name_2, opening_date: "2013-01-01", contact_person: "Koubaka Robert", phone_number: "578451245", email: "robert@gmail.com", address: "adresse de Robert", id: random_id }
    ]

    status = Dhis2.client.organisation_units.create(org_units)

    assert_equal true, status.success?
    assert_equal 2, status.total_imported

    org_unit_1 = Dhis2.client.organisation_units.list(fields: :all, filter: "name:eq:#{org_unit_name_1}").first

    assert_equal org_unit_name_1, org_unit_1.short_name
    assert_equal "test@gmail.com", org_unit_1.email
    assert_equal "57401156", org_unit_1.phone_number
    assert_equal random_id, org_unit_1.id
    assert_equal nil, org_unit_1.address
    assert_equal "Zulumur Roland", org_unit_1.contact_person
  end

  def test_update_org_units
    org_unit_name   = SecureRandom.uuid
    attributes      = { name: org_unit_name, short_name: org_unit_name, opening_date: "2013-01-01" }
    Dhis2.client.organisation_units.create(attributes)
    org_unit         = Dhis2.client.organisation_units.list(fields: :all, filter: "name:eq:#{org_unit_name}").first
    new_attributes   = { name: SecureRandom.uuid }
    org_unit.update_attributes(new_attributes)
    updated_org_unit = Dhis2.client.organisation_units.find(org_unit.id)
    assert_equal(org_unit.name, new_attributes[:name])
    assert_equal(updated_org_unit.name, org_unit.name)
  end
end
