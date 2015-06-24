Given /^I am on the Default Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Given /^I am on the Settings Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
  touch("button marked:'settings'")
  sleep(STEP_PAUSE)
end