Feature: Show primary calendar
  As an calendar user
  I want to see my default calendar
  So I can see my basic events

Scenario: Show top events
  Given I am on the Default Screen
  Then I should see "1"
  Then I should see "日"
  And take picture

Scenario: Show following events
  Given I am on the Default Screen
  And I scroll table down
  Then I should see "28"
  Then I should see "土"
  And take picture