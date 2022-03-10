require "application_system_test_case"

class LinksToUserProfileTest < ApplicationSystemTestCase
   def setup 
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @generated_code = Team.generate_team_code
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)     
    @bob.teams << @team

    end

    def test_link_to_user_profile_from_manage_users
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

