require "application_system_test_case"


class TeamCapacityTest < ApplicationSystemTestCase

    setup do
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @generated_code = Team.generate_team_code
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)
        @team1 = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
        @smith.teams << @team1
        @bob.teams << @team
    end

    def test_team_capacity_full
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Manage Teams"
        assert_text "Team Complete"
    end

    def test_team_capacity_not_full
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Manage Teams"
        assert_text "1/5"
    end

    def test_team_capacity_add_to_full_team
        visit root_url
      click_on "Sign Up"

      fill_in "user[first_name]", with: "Scott"
      fill_in "user[last_name]", with: "F"
      fill_in "user[team_code]", with: "TEAM00"
      fill_in "user[email]", with: "SCOTTF@gmail.com"
      fill_in "user[password]", with: "testpassword"
      fill_in "user[password_confirmation]", with: "testpassword"
      click_on "Create account"
      
      assert_text "Teams is full. If you believe this is an error, please contact your professor."
      assert_current_path users_url 

    end

    def test_create_team_blank_capacity
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Manage Teams"
        find('#new-team-link').click
        fill_in "Team name", with: "Test Team"
        fill_in "Team code", with: "TEAM01"
        click_on "Create Team"

        assert_text "Capacity is not a number"
        assert_text "Capacity can't be blank"

    end

    def test_create_team_negative_capacity
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Manage Teams"
        find('#new-team-link').click
        fill_in "Team name", with: "Test Team"
        fill_in "Team code", with: "TEAM02"
        fill_in "Capacity", with: -5
        click_on "Create Team"

        assert_text "Capacity must be greater than 0"
    end

    def test_create_team_with_capacity
        visit root_url
        login 'msmucker@gmail.com', 'professor'

        click_on "Manage Teams"
        find('#new-team-link').click
        fill_in "Team name", with: "Test Team"
        fill_in "Team code", with: "TEAM03"
        fill_in "Capacity", with: 5
        click_on "Create Team"

        assert_text "Team was successfully created."
    end

end