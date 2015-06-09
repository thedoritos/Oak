Feature: Show events picker
  As an calendar user
  I want to set events on calendar
  So I can remember my events

Scenario: Show event picker
  Given I am on the Default Screen
  Then I touch list item number 1
  Then I should see "Events"
  And take picture