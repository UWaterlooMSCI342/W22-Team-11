require "application_system_test_case"

class LinksToUserProfileTest < ApplicationSystemTestCase
    def setup
        Option.create(reports_toggled: true)
        prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: "Smucker", is_admin: true, password: 'professor', password_confirmation: 'professor')
      end

      def test_link_to_user_profile_from_manage_teams
        user = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
        team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 6)
        team.user = @prof
        team.users = [user]
        team.save!
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        assert_current_path root_url
        click_on "Manage Teams"
        assert_current_path teams_url
        click_on "CharlesSmith"
        assert_current_path user_path(user.id)
      end

end
