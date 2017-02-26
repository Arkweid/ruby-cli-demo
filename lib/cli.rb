require "thor"
require "version"
require "commands/configure"
require "commands/color"
require "commands/rainbow"

class CLI < Thor
  #def initialize(commands = {})
  #  @commands = @commands
  #end
  #attr_reader :commands

  desc "configure", "Configure your Particle button"
  def configure
    Commands::Configure.new.run
  end

  desc "color COLOR", "Turn on lights this color"
  def color(name)
    Commands::Color.new.run(name)
  end

  desc "rainbow", "Make lights rainbow"
  def rainbow
    puts rainbow
  end

  desc "version", "Show the program version"
  def version
    puts CLI_VERSION
  end

  map %w(-v --version) => :version
end
