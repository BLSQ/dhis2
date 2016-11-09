require "test_helper"

class SystemInfoTest < Minitest::Test
  def test_get_system_info
    system_info = Dhis2.client.system_infos.get

    refute_nil system_info["version"]
    refute_nil system_info["context_path"]
    refute_nil system_info["database_info"]
    refute_nil system_info["date_format"]
  end
end
