require "tty-prompt"
require "tty-spinner"

class UI
  def say(message)
    puts message
  end

  def ask(question, options = {})
    if options[:password]
      prompt.mask(question)
    else
      prompt.ask(question, options)
    end
  end

  def with_spinner(message = "", &block)
    s = TTY::Spinner.new(":spinner #{message}", format: :arrow_pulse)
    s.run(&block)
  end

  def select(question, items)
    prompt.select(question, items)
  end

  private

  def prompt
    @prompt ||= TTY::Prompt.new
  end
end
