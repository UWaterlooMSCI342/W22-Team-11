require "application_system_test_case"

# Acceptance Criteria: 
# 1. As a student, I should be able to see help instructions regarding submission of feedbacks
# 2. As a student, I should be able to see help instructions regarding submission of reports

class AddReportsTogglesTest < ApplicationSystemTestCase
  setup do
    Option.create(reports_toggled: true)
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
    @steve = User.create(email: 'steve@gmail.com', first_name: 'Steve', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @steve.teams << @team
  end
  
  def test_feedback_instructions
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'steve@gmail.com', 'testpassword'    
    
    click_on "Submit for"
    # assert_text "Please select a rating on how well you believe your team performed this period and the priority of your feedback from the dropdowns below. These fields are mandatory.\nYou may enter optional comments in the text area below with a maximum of 2048 characters."
    assert_text "Please select a rating on how well you believe your team performed this period for each of the following categories:"
    assert_text "Collaboration and Engagement Communication Team Support Responsibility Work Quality" 
    assert_text "These fields are ranked on a number scale from 1 to 5, and are mandatory."
  end
  
  
end