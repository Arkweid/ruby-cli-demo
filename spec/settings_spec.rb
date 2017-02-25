require "settings"

RSpec.describe Settings do
  describe "#default_filename" do
    it "is a file" do
      expected = '~/.button-cli.yaml'
      actual = Settings.new.default_filename
      expect(File.expand_path(actual)).to eq(File.expand_path(expected))
    end
  end

  describe "#filename" do
    it "is set from the constructor" do
      path = "/tmp/settings.yaml"
      settings = Settings.new(path)
      expect(settings.filename).to eq path
    end
    it "uses default_filename when no constructor parameter is passed" do
      settings = Settings.new
      expect(settings.filename).to eq settings.default_filename
    end
  end
end
