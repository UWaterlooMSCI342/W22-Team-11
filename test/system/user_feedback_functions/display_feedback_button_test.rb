require "application_system_test_case"
class DisplayFeedbackButtonTest < ApplicationSystemTestCase
    include FeedbacksHelper
    setup do
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'banana', password_confirmation: 'banana')
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 2)
        @smith.teams << @team
    end

    def test_no_button_before_monday
        travel_to Time.new(2022, 03, 14, 06, 04, 44)
        visit root_url 
        login 'smith@gmail.com', 'testpassword'
        assert_no_text "Submit for: Test Team"
    end

    def test_no_button_before_tuesday
        travel_to Time.new(2022, 03, 15, 06, 04, 44)
        visit root_url 
        login 'smith@gmail.com', 'testpassword'
        assert_no_text "Submit for: Test Team"
    end

    def test_display_button_on_wednesday
        travel_to Time.new(2022, 03, 16, 06, 04, 44)
        visit root_url 
        login 'smith@gmail.com', 'testpassword'
        assert_text "Submit for: Test Team"
    end

    def test_display_button_on_sunday
        travel_to Time.new(2022, 03, 20, 06, 04, 44)
        visit root_url 
        login 'smith@gmail.com', 'testpassword'
        assert_text "Submit for: Test Team"
    end
end