require "application_system_test_case"


class TeamCapacityTest < ApplicationSystemTestCase

    setup do
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @generated_code = Team.generate_team_code
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