#Feature: Configure Command
#  Background:
#    Given a mocked home directory
#
#  Scenario: Perform login and select device
#    When I run `button configure` interactively
#    And I type "test@gmail.com"
#    And I type "password"
#    And I type ""
#    Then the output should contain "All set!"
#    And the file "~/.button-cli.yaml" should contain "access_token:"
#    And the file "~/.button-cli.yaml" should contain "device:"
