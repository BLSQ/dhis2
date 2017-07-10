# frozen_string_literal: true

def fixture_content(type, name)
  File.read(File.join("spec", "fixtures", type.to_s, name))
end
