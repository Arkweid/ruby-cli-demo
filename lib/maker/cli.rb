require "thor"

module Maker
  class CLI < Thor
    desc "login", "Log in to your Particle account"
    def login
      puts "login"
    end

    desc "a FOOD", "What you would like to have?"
    def a(item)
      puts item
    end
  end
end
