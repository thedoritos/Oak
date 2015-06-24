Given /^I clear the "([^\"]*)" input field$/ do |name|
  clear_text("textField marked:'#{name}'")
end