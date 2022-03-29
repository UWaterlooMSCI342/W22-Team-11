require "application_system_test_case"

# If a student does not submit feedback for a week by the Sunday 6pm, 
#their rating that week automatically becomes the lowest possible rating available on the system
class AutoAssignTest < ApplicationSystemTestCase
    include FeedbacksHelper
    setup do
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'banana', password_confirmation: 'banana')
        @team1 = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
        @smith.teams << @team1
        @bob.teams << @team1
    end

    #Acceptance Criteria: As a student, if I fail to submit feedback in time, my feedback will default to 0 out of 10.
    def test_student_sees_auto_feedback
        travel_to Time.new(2022, 03, 27, 06, 04, 44)
        visit root_url 
        login 'smith@gmail.com', 'testpassword'
        assert_text("0")
        assert_text("High")
    end

    #Acceptance Criteria: As an instructor, if a student has a rating of 0, then they did not submit feedback for the week and a comment will say that
    def test_instructor_auto_feedback
        travel_to Time.new(2022, 03, 27, 06, 04, 44)
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
        click_on "Manage Users"
        click_on "Bob Smith"
        assert_text("0")
        assert_text("User did not submit feedback for this period")
    end

    #Acceptance Criteria: As an instructor, the priority should be high if a student did not submit feedback 
    def test_unsubmitted_priority_high
        travel_to Time.new(2022, 03, 27, 06, 04, 44)
        visit root_url 
        login 'msmucker@gmail.com', 'banana'
        assert_text("High")
    end
end