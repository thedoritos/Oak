Given /^I scroll table down$/ do
  num_rows = query("tableView index:0", numberOfRowsInSection:0).first
  scroll_to_row('tableView index:0', num_rows - 1)
  sleep(STEP_PAUSE)
end