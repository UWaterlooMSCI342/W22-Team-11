require "application_system_test_case"

class LinkToHelpPage < ApplicationSystemTestCase
    def setup
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
        @user = User.create(email: 'zappy@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Zappy', last_name: 'Zoo', is_admin: false, teams: [@team])
        @user.save
    end

    def test_link_to_help_page_from_home
        visit root_url
        login 'zappy@gmail.com','banana'
        assert_current_path root_url

        click_link 'Help'
        assert_text 'Help page'
    end

    def test_link_to_help_page_from_submit_feedback
        visit root_url
        login 'zappy@gmail.com','banana'
        assert_current_path root_url

        click_link 'Submit for: Test Team'
        assert_current_path new_feedback_url
        assert_text 'Your Current Team: Test Team'

        click_link 'Help'
        assert_text 'Help Page'
    end

end