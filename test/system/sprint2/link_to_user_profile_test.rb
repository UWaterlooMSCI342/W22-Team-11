require "application_system_test_case"

class LinksToUserProfileTest < ApplicationSystemTestCase
   def setup 
    @prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    @user = User.create(email: 'zappy@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Zappy Zoo', is_admin: false, teams: [@team])
    @user.save
    end

    def test_link_to_user_profile_from_manage_teams
        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        visit teams_url
        assert_current_path teams_url
        click_link(@user.name)
        assert_current_path user_path(@user)
    end

end

