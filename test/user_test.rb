require "test_helper"

class UserTest < Minitest::Test
  def test_list_users
    users = Dhis2.client.users.list(fields: :all, page_size: 1)
    assert_equal 1, users.size

    user = users.first

    refute_nil user.display_name
    refute_nil user.id
    refute_nil user.first_name
    refute_nil user.surname
  end

  def test_get_user
    users = Dhis2.client.users.list(fields: %w(id displayName), page_size: 1)
    user = Dhis2.client.users.find(users.first.id)

    refute_nil user.display_name
    refute_nil user.id
    refute_nil user.first_name
  end
end
