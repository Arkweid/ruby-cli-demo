class Settings
  def initialize(filename = nil)
    @filename = filename || default_filename
  end
  attr_reader :filename

  def default_filename
    "~/.button-cli.yaml"
  end
end
