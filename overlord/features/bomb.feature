Feature: Bomb

  As a super-villain bent on dominating the world's information history
  I need an eigenstate-selecting temporal dispersion Internet bomb
  so that I can destroy online information across all probable time-lines.

  Scenario: A newly booted bomb is not active
    When a bomb is booted for the first time
    Then the bomb will display as inactive

  @javascript
  Scenario: Bombs can be activated with valid activation codes
    Given a newly booted bomb
    When entering a valid activation code
    Then the bomb will display as active

