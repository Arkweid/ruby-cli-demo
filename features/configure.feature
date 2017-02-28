Feature: Configure Command
  Background:
    Given a mocked home directory

  Scenario: Perform login and select device
    Given I run `button configure` interactively
    And I type "test@example.com"
    And I type "password"
    And I type "\n"
    Then the output should contain "You are all set"
    And the file "~/.button-cli.yaml" should contain "access_token:"
    And the file "~/.button-cli.yaml" should contain "device:"
