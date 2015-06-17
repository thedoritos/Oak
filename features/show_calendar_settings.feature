Feature: Show calendar settings
  As an calendar user
  I want to set settings for calendar
  So I can only show calendars I need

Scenario: Show settings
  Given I am on the Default Screen
  Then I should see "settings"
  Then I touch "settings"
  And take picture