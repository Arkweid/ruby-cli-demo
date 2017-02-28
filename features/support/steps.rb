require "io/console"

When(/^I respond to the prompt "([^"]*)" with "([^"]*)"$/) do |prompt, response|
  begin
    Timeout.timeout(aruba.config.exit_timeout) do
      loop do
        begin
          expect(last_command_started).to have_interactive_stdout an_output_string_including(prompt)
        rescue RSpec::Expectations::ExpectationNotMetError
          sleep 1
          retry
        end
        break
      end
    end
  rescue TimeoutError
    expect(last_command_started).to have_interactive_stdout an_output_string_including(prompt)
  end
  step "I type \"#{response}\""
end

RSpec::Matchers.define :have_interactive_stdout do |expected|
  match do |actual|
    @actual = sanitize_text(actual.stdout)
    puts @actual

    values_match?(expected, @actual)
  end

  diffable

  description { "have output: #{description_of expected}" }
end
