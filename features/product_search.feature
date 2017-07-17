@any_env @any_browser @fixture_demo
Feature: Product Search Functionality
  As a customer
  I want to search the storefront
  In order to see what products you have that match my needs
  AC#1: Narrow search that finds 1 product
  AC#2: Wide search that finds >3 products
  AC#3: No results
  AC#4: Don't allow injections

  @search
  Scenario Outline: Search for individual products
    Given I have searched for <product>
    Then I see a single product in the results
    Examples:
      | product             |
      | Science & Faith     |
      | Adobe Photoshop CS4 |

  @search
  Scenario: Search for a group of products
    Given I have searched for "HTC"
    Then I see a related product "HTC One Mini Blue"
    And I see a related product "HTC One M8 Android L 5.0 Lollipop"

  @search @negative
  Scenario: Search for a non-existent product
    Given I have searched for "ZZZZ"
    Then I see a message "No products were found that matched your criteria."

  @search @negative
  Scenario Outline: Error out on html or SQL injection
    Given I have searched for <term>
    Then I see a message "We're sorry, an internal error occurred"
    Examples:
    |term|
    |<b> |
    |<script='alert("hello");'></script>  |