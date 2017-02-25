require "settings"
require "tempfile"

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

  describe "#[]" do
    it "accesses values" do
      settings = Settings.new
      settings[:foo] = "bar"
      expect(settings[:foo]).to eq "bar"
    end
  end

  describe "#load" do
    it "loads from the file" do
      Tempfile.open('settings.yaml') do |f|
        f.write(%q(
                token: XXXXXXXXXXXXXXXX
                device: button
                ))
        f.close

        settings = Settings.new(f.path)
        settings.load
        expect(settings[:token]).to eq "XXXXXXXXXXXXXXXX"
        expect(settings[:device]).to eq "button"
      end
    end

    it "doesn't crash when the file is missing" do
      settings = Settings.new("/missing")
      expect { settings.load }.not_to raise_error
    end
  end
end
