require "tty-prompt"

module Maker
  class UI
    def ask(question, options = {})
      if options[:password]
        prompt.mask(question)
      else
        prompt.ask(question, options)
      end
    end

    private

    def prompt
      @prompt ||= TTY::Prompt.new
    end
  end
end
