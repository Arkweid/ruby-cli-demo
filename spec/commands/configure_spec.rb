require "commands/configure"
require "ui"
require "settings"

RSpec.describe Commands::Configure do
  subject { described_class.new(settings: settings, ui: ui, api: api) }
  let(:settings) { Settings.new }
  let(:ui) { double("UI") }
  let(:api) { double }
  describe "#greet" do
    it "says stuff" do
      expect(ui).to receive(:say)

      subject.greet
    end
  end

  describe "#ask_login" do
    it "sets email and password" do
      expect(ui).to receive(:ask).with("What's your Particle email?", required: true).and_return("me@example.com")
      expect(ui).to receive(:ask).with("What's your Particle password?", mask: true).and_return("password")

      subject.ask_login

      expect(subject.email).to eq "me@example.com"
      expect(subject.password).to eq "password"
    end
  end

  describe "#perform_login" do
    it "calls the api" do
      subject.email = "me@example.com"
      subject.password = "password"

      expect(api).to receive(:login).with("me@example.com", "password")

      subject.perform_login
    end
  end

  describe "#get_devices" do
    it "sets the devices" do
      devices = [double]
      expect(api).to receive(:devices).and_return(devices)

      subject.get_devices

      expect(subject.devices).to eq devices
    end
  end

  describe "#select_device" do
    it "sets the selected device" do
      device = double
      expect(device).to receive(:name).and_return("the_button")
      subject.devices = [device]
      expect(ui).to receive(:select).with("Which device is in the button?", ["the_button"]).and_return("the_button")

      subject.select_device

      expect(subject.device_name).to eq "the_button"
    end
  end

  describe "#save_settings" do
    it "saves" do
      expect(api).to receive(:access_token).and_return("XXXXXXXXXXXXXXXX")
      subject.device_name = "the_button"
      expect(settings).to receive(:save)

      subject.save_settings

      expect(settings.values).to eq(
        "access_token" => "XXXXXXXXXXXXXXXX",
        "device" => "the_button"
      )
    end
  end

  describe "#bye" do
    it "says stuff" do
      expect(ui).to receive(:say)

      subject.bye
    end
  end

  describe "#run" do
    it "runs" do
      allow(ui).to receive(:with_spinner).and_yield
      expect(subject).to receive(:greet)
      expect(subject).to receive(:ask_login)
      expect(subject).to receive(:perform_login)
      expect(subject).to receive(:get_devices)
      expect(subject).to receive(:select_device)
      expect(subject).to receive(:save_settings)
      expect(subject).to receive(:bye)

      subject.run
    end
  end
end
