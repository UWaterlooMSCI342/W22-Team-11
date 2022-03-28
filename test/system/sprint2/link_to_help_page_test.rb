require "application_system_test_case"

class LinkToHelpPage < ApplicationSystemTestCase
    setup do
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @generated_code = Team.generate_team_code
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)
        @bob.teams << @team
    end

    def test_link_to_help_page_from_home
        visit root_url
        login 'bob@gmail.com','testpassword'
        assert_current_path root_url

        click_link 'Help'
        assert_text 'Help Page'
    end

    def test_link_to_help_page_from_submit_feedback
        travel_to Time.new(2022, 03, 16, 06, 04, 44)
        visit root_url
        login 'bob@gmail.com','testpassword'
        assert_current_path root_url

        click_link 'Submit for: Test Team'
        assert_current_path new_feedback_url
        assert_text 'Your Current Team: Test Team'

        click_link 'Help'
        assert_text 'Help Page'
    end

end