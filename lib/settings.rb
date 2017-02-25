require "yaml"

class Settings
  def initialize(filename = nil)
    @filename = filename || default_filename
    @values = {}
  end
  attr_reader :filename

  def default_filename
    "~/.button-cli.yaml"
  end

  def [](key)
    @values[key.to_s]
  end

  def []=(key, value)
    @values[key.to_s] = value
  end

  def load
    file_content = File.open(filename, 'r').read
    @values = YAML.load(file_content)
  rescue Errno::ENOENT
    # Don't worry if file is not there
  end

  def save
    File.open(filename, 'w') do |f|
      file_content = YAML.dump @values
      f.write file_content
    end
  end
end
