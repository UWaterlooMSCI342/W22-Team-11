require "application_system_test_case"


class TeamNavigationTest < ApplicationSystemTestCase

    setup do
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @team1 = Team.create(team_name: 'Test Team1', team_code: 'TEAM00', user: @prof, capacity: 5)
        @team2 = Team.create(team_name: 'Test Team2', team_code: 'TEAM01', user: @prof, capacity: 5)
        @team3 = Team.create(team_name: 'Test Team3', team_code: 'TEAM03', user: @prof, capacity: 5)
        @team4 = Team.create(team_name: 'Test Team4', team_code: 'TEAM04', user: @prof, capacity: 5)   
    end

    def test_clicking_previous_team_from_first_team_reloads_page
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team1)

        click_on "Previous Team"

        assert_current_path team_path(@team1)
    end

    def test_clicking_next_team_from_last_team_reloads_page
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team4)

        click_on "Next Team"

        assert_current_path team_path(@team4)
    end

    def test_clicking_previous_team_navigates_to_previous_team
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team4)

        click_on "Previous Team"

        assert_current_path team_path(@team3)
    end
    
    def test_clicking_next_team_navigates_to_next_team
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team2)

        click_on "Next Team"

        assert_current_path team_path(@team3)
    end

    def test_clicking_next_team_navigates_to_next_existing_team_when_team_inbetween_is_deleted
        @team3.delete
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team2)

        click_on "Next Team"

        assert_current_path team_path(@team4)
    end

    def test_clicking_previous_team_navigates_to_previous_existing_team_when_team_inbetween_is_deleted
        @team2.delete
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        visit team_path(@team3)

        click_on "Previous Team"

        assert_current_path team_path(@team1)
    end

end
    

