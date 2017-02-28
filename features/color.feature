Feature: Color Command
  Background:
    Given a mocked home directory
    And a file named "~/.button-cli.yaml" with:
    """
    access_token: XXXXXXXXXXXX
    device: button_electron
    """

  Scenario: Send the command
    When I run `button color green` interactively
    Then the output should contain "See that beautiful green"

