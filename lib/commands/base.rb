require "settings"
require "ui"
require "particlerb"

module Commands
  class Base
    def initialize(settings: Settings.new, ui: UI.new, api: Particle)
      @settings = settings
      @ui = ui
      @api = api
    end
    attr_reader :settings, :ui, :api
  end
end

