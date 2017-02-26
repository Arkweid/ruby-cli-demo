require "thor"
require "version"
require "commands/configure"
require "commands/color"
require "commands/rainbow"

class CLI < Thor
  COMMANDS = {
    configure: Commands::Configure,
    color: Commands::Color,
    rainbow: Commands::Rainbow
  }
  def initialize(args = [], local_options = {}, config = {})
    @commands = config.delete(:commands) { COMMANDS }
    super
  end
  attr_reader :commands

  desc "configure", "Configure your Particle button"
  def configure
    commands[:configure].new.run
  end

  desc "color COLOR", "Turn on lights this color"
  def color(name)
    commands[:color].new.run(name)
  end

  desc "rainbow", "Make lights rainbow"
  def rainbow
    commands[:rainbow].new.run
  end

  desc "version", "Show the program version"
  def version
    puts CLI_VERSION
  end

  map %w(-v --version) => :version
end
