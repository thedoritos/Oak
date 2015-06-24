Feature: Show calendar settings
  As an calendar user
  I want to set settings for calendar
  So I can only show calendars I need

Scenario: Show settings
  Given I am on the Default Screen
  Then I should see "settings"
  Then I touch "settings"
  Then I should see "TITLE"
  Then I should see "TIME"
  And take picture

Scenario: Edit title
  Given I am on the Settings Screen
  Then I clear the "text field" input field
  Then I enter "Demo Event" into the "text field" input field
  Then I touch "Done"
  And take picture