require "application_system_test_case"

class ShowRespondedColumnTest < ApplicationSystemTestCase
   def setup 
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @generated_code = Team.generate_team_code
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)     
    @bob.teams << @team

    end

    def test_show_responded_column_if_low_feedback
        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        visit users_url
        assert_current_path users_url
        click_on "Bob"
        #click_link(@bob)
        assert_current_path user_path(@bob)
    end

end