@test
Feature: Main page functionality, everything starts from the main page

#  Background:
#    Given i am on the main page

  Scenario: To test everything works
    Given I am on the main page
    And I click on the sign in button

  Scenario: To search a pizza
    Given I am on the main page
    And I search "Chicago"

  Scenario: Login as a registered user
    Given I am on the main page
    And I login as a registered user
    Then I see my username in the page
    Then I " abc" and "cdf"

