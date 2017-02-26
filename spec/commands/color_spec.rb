require "commands/configure"
require "ui"
require "settings"

RSpec.describe Commands::Color do
  subject { described_class.new(settings: settings, ui: ui, api: api) }
  let(:settings) { Settings.new }
  let(:ui) { double("UI") }
  let(:api) { double }

  describe "#load_settings" do
    it "loads" do
      expect(settings).to receive(:load)

      subject.load_settings
    end

    it "sets the instance variables" do
      settings[:access_token] = "XXXXXXXXXXXXXXXX"
      settings[:device] = "dev"

      subject.load_settings

      expect(subject.access_token).to eq "XXXXXXXXXXXXXXXX"
      expect(subject.device_name).to eq "dev"
    end
  end

  describe "#configured?" do
    it "returns true when token and device are available" do
      subject.device_name = "dev"
      subject.access_token = "XXXXXXXXXXXXXXXX"

      expect(subject.configured?).to be true
    end

    it "returns false when token and device are not available" do
      expect(subject.configured?).to be false
    end
  end

  describe "#not_configured" do
    it "says stuff" do
      expect(ui).to receive(:say)

      subject.not_configured
    end
  end

  describe "#configure_api" do
    it "passes the token" do
      subject.access_token = "XXXXXXXXXXXXXXXX"
      expect(api).to receive(:access_token=).with("XXXXXXXXXXXXXXXX")

      subject.configure_api
    end
  end

  describe "#color_hex_from_name" do
    it "returns the HTML value" do
      color = "red"
      hex = "#ff0000"
      expect(subject.color_hex_from_name(color)).to eq hex
    end

    it "returns a default value for an unknown color" do
      color = "blarg"
      hex = "#ffffff"
      expect(subject.color_hex_from_name(color)).to eq hex
    end
  end

  describe "#convert_color_to_hex" do
    it "sets the hex color" do
      expect(subject).to receive(:color_hex_from_name).with("blue").and_return("#0000ff")

      subject.convert_color_to_hex("blue")

      expect(subject.color_hex).to eq "#0000ff"
    end
  end

  describe "#send_device_color" do
    it "calls the color device function" do
      subject.device_name = "dev"
      subject.color_hex = "#0000ff"
      device = double
      expect(api).to receive(:device).with("dev").and_return(device)
      expect(device).to receive(:function).with("color", "#0000ff")

      subject.send_device_color
    end
  end

  describe "#bye" do
    it "says stuff" do
      expect(ui).to receive(:say)

      subject.bye("blue")
    end
  end

  describe "#run" do
    it "runs when configured" do
      allow(ui).to receive(:with_spinner).and_yield
      expect(subject).to receive(:load_settings)
      expect(subject).to receive(:configured?).and_return(true)
      expect(subject).to receive(:configure_api)
      expect(subject).to receive(:convert_color_to_hex).with("blue")
      expect(subject).to receive(:send_device_color)
      expect(subject).to receive(:bye).with("blue")

      subject.run("blue")
    end

    it "returns early when not configured" do
      allow(ui).to receive(:with_spinner).and_yield
      expect(subject).to receive(:load_settings)
      expect(subject).to receive(:configured?).and_return(false)
      expect(subject).to receive(:not_configured)

      subject.run("blue")
    end
  end
end
