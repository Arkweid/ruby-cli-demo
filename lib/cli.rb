require "thor"

class CLI < Thor
  desc "login", "Log in to your Particle account"
  def login
    puts "login"
  end

  desc "color COLOR", "Turn on lights this color"
  def color(name)
    puts "color #{name}"
  end

  desc "rainbow", "Make lights rainbow"
  def rainbow
    puts rainbow
  end
end
