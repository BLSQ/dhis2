# frozen_string_literal: true

def shared_content(name)
  File.read(File.join("spec", "fixtures", name))
end

def fixture_content(version, type, name)
  File.read(File.join("spec", "fixtures", version, type.to_s, name))
end

def generic_fixture_content(version, name)
  File.read(File.join("spec", "fixtures", version, name))
end