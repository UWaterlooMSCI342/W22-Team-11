require "application_system_test_case"

# Acceptance Criteria
# 1. As a user, I should be able to view a help page regarding feedback results
#    for team summary view
# 2. As a user, I should be able to view a help page regarding feedback results for detailed
#    team view

class HelpPageTest < ApplicationSystemTestCase
  setup do
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
  end
  
  # (1)
  def test_home_help
    visit root_url 
    login 'msmucker@gmail.com', 'professor'
    click_on 'Help'
    assert_text 'Help page'
  end

  # (2)
  def test_teams_view_help
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    user = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false, teams: [team])
    user.save!
    feedback = Feedback.new(communication: 1, comments: "This team is disorganized", responsibility: 1, work_quality: 1, team_support:1, collaboration: 1)
    feedback.timestamp = feedback.format_time(DateTime.now)
    feedback.user = user
    feedback.team = user.teams.first
    feedback.save!

    visit root_url
    login 'msmucker@gmail.com', 'professor' 
    click_on 'Details'
    click_on 'Help'
    assert_text "Team's Individual Feedback"
  end
end