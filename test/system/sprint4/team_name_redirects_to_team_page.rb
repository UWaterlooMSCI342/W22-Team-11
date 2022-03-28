require "application_system_test_case"

# Acceptance Criteria:
# 1. Instructor should be able to click a team's name on the home page and be redirected to the team's "show" page

class TeamNameRedirectsToTeamPage < ApplicationSystemTestCase
    setup do
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @user1 = User.new(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: true)
        @team1 = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
        @team1.user = @prof
        @team1.save
        @user1.teams << @team1
    end

    def test_teamname_redirects_to_show_team
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        assert_current_path root_url

        # received assistance for line of code below from https://stackoverflow.com/questions/14513377/how-to-click-first-link-in-list-of-items-after-upgrading-to-capybara-2-0
        first("##{@team1.id}").click_link('Team 1')
        assert_current_path "/teams/#{@team1.id}"
    end
end