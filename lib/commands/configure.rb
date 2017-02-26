require "settings"
require "commands/base"
require "ui"
require "particlerb"

module Commands
  class Configure < Base
    attr_accessor :email, :password, :devices, :device_name

    def run
      greet
      ask_login
      ui.with_spinner "Logging in" do
        perform_login
        get_devices
      end
      select_device
      save_settings
      bye
    end

    def greet
      ui.say "Let's configure your button"
    end

    def ask_login
      self.email = ui.ask "What's your Particle email?", required: true
      self.password = ui.ask "What's your Particle password?", password: true
    end

    def perform_login
      api.login email, password
    end

    def get_devices
      self.devices = api.devices
    end

    def select_device
      names = devices.map { |d| d.name }
      self.device_name = ui.select("Which device is in the button?", names)
    end

    def save_settings
      settings[:access_token] = api.access_token
      settings[:device] = device_name
      settings.save
    end

    def bye
      ui.say "All set! You can use other commands now!"
    end
  end
end
