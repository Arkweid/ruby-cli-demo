require "commands/base"
require "color"

module Commands
  class Color < Base
    DEFAULT_COLOR = "#ffffff"
    attr_accessor :access_token, :device_name, :color_hex

    def run(color)
      load_settings
      return not_configured unless configured?
      configure_api
      convert_color_to_hex(color)
      ui.with_spinner do
        send_device_color
      end
      bye(color)
    end

    def load_settings
      settings.load
      self.access_token = settings[:access_token]
      self.device_name = settings[:device]
    end

    def configured?
      return false if access_token.nil? || access_token.empty?
      return false if device_name.nil? || device_name.empty?
      true
    end

    def not_configured
      ui.say "Run the configure command first."
    end

    def configure_api
      api.access_token = access_token
    end

    def convert_color_to_hex(name)
      self.color_hex = color_hex_from_name(name)
    end

    def color_hex_from_name(name)
      found = ::Color::CSS[name]
      return DEFAULT_COLOR if found.nil?
      found.html
    end

    def send_device_color
      device = api.device(device_name)
      device.function("color", color_hex)
    end

    def bye(color)
      ui.say "See that beautiful #{color}"
    end
  end
end
