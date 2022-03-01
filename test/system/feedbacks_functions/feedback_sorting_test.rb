require "application_system_test_case"


class FeedbackSortingTest < ApplicationSystemTestCase
    setup do
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @generated_code = Team.generate_team_code
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)
        @team1 = Team.create(team_name: 'Another Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
        @smith.teams << @team1
        @bob.teams << @team
    end

    def test_order_by_team
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Feedback & Ratings"

        assert_equal()

    end













end
