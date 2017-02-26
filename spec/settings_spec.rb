require "settings"
require "tempfile"

RSpec.describe Settings do
  describe "#default_filename" do
    it "is a file" do
      expected = "~/.button-cli.yaml"

      actual = described_class.new.default_filename

      expect(File.expand_path(actual)).to eq(File.expand_path(expected))
    end
  end

  describe "#filename" do
    it "is set from the constructor" do
      path = "/tmp/settings.yaml"

      settings = described_class.new(path)

      expect(settings.filename).to eq path
    end
    it "uses default_filename when no constructor parameter is passed" do
      settings = described_class.new

      expect(settings.filename).to eq settings.default_filename
    end
  end

  describe "#[]" do
    it "accesses values" do
      settings = described_class.new

      settings[:foo] = "bar"

      expect(settings[:foo]).to eq "bar"
    end
  end

  describe "#load" do
    it "loads from the file" do
      Tempfile.open("settings.yaml") do |f|
        f.write [
          "---",
          "token: XXXXXXXXXXXXXXXX",
          "device: button",
          ""
        ].join("\n")
        f.close
        settings = described_class.new(f.path)

        settings.load

        expect(settings[:token]).to eq "XXXXXXXXXXXXXXXX"
        expect(settings[:device]).to eq "button"
      end
    end

    it "doesn't crash when the file is missing" do
      settings = described_class.new("/missing")
      expect { settings.load }.not_to raise_error
    end
  end

  describe "#save" do
    it "saves the file" do
      Tempfile.open("settings.yaml") do |f|
        settings = described_class.new(f.path)
        settings[:token] = "XXXXXXXXXXXXXXXX"
        settings[:device] = "button"

        settings.save

        content = f.read
        expected = [
          "---",
          "token: XXXXXXXXXXXXXXXX",
          "device: button",
          ""
        ].join("\n")
        expect(content).to eq expected
      end
    end
  end
end
