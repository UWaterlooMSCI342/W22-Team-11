require "application_system_test_case"


class ReleaseFeedbackTest < ApplicationSystemTestCase
    include FeedbacksHelper
    setup do
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'banana', password_confirmation: 'banana')
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 1)
        @team1 = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
        @smith.teams << @team1
        @bob.teams << @team1
    end

    def test_professor_view_all_submit
        travel_to Time.new(2022, 03, 10, 06, 04, 44)
        feedback = save_feedback(5, 5, 5, 5, 5, "Week 9 data 1", @bob, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 0)
        feedback1 = save_feedback(5, 5, 5, 5, 5, "Comment", @smith, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 0)
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
        assert_text "10"
        assert_text "High"

    end

    def test_professor_view_not_all_submit_Sunday
        travel_to Time.new(2022, 03, 13, 06, 04, 44)
        
        feedback = save_feedback(5, 5, 5, 5, 5, "Week 9 data 1", @bob, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 0)
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
        assert_text "Missing Feedback"
        assert_text "10"

    end

    def test_professor_view_not_all_submit_not_Sunday
        travel_to Time.new(2022, 03, 10, 06, 04, 44)
        
        feedback = save_feedback(5, 5, 5, 5, 5, "Week 9 data 1", @bob, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 0)
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
        assert_text "-"
        assert_text "Missing Feedback"

    end

    def test_view_empty_team_professor
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
    end

    def test_student_view_all_submit
        travel_to Time.new(2022, 03, 10, 06, 04, 44)
    
        feedback = save_feedback(5, 5, 5, 5, 5, "Week 9 data 1", @bob, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 2)
        feedback1 = save_feedback(5, 5, 5, 5, 5, "Comment", @smith, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 2)
        visit root_url 
        login 'bob@gmail.com', 'testpassword'

        assert_text "None"
        assert_text "10"
    end

    def test_student_not_all_submit_Sunday
        travel_to Time.new(2022, 03, 13, 06, 04, 44)
        feedback = save_feedback(5, 5, 5, 5, 5, "Week 9 data 1", @bob, DateTime.civil_from_format(:local, 2022, 3, 8), @team1, 0)
        visit root_url 
        login 'bob@gmail.com', 'testpassword'

        assert_text "Missing Feedback"
        assert_text "10"
    end

    def test_submit_not_all_sumbit_not_Sunday
        travel_to Time.new(2022, 03, 10, 06, 04, 44)
        visit root_url 
        login 'bob@gmail.com', 'testpassword'
        assert_text "-"
        assert_text "Missing Feedback"
    end


end