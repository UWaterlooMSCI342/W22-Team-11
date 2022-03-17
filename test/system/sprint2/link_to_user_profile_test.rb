#W22-Team-11/test/system/sprint3/one_feedback_per_week_test.rb
require "application_system_test_case"

class LinksToUserProfileTest < ApplicationSystemTestCase
   def setup 
    #@prof = User.create(email: 'msmucker@gmail.com', name: 'Mark Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof)
    #@user = User.create(email: 'zappy@gmail.com', password: 'banana', password_confirmation: 'banana', name: 'Zappy Zoo', is_admin: false, teams: [@team])
    @user = User.create(email: 'zappy@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Zappy', last_name: 'Zoo', is_admin: false, teams: [@team])
    @user.save
   end

end

