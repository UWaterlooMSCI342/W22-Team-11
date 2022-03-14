require "application_system_test_case"

class StudentHistFeedbackTest < ApplicationSystemTestCase
    def setup 
        @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
        @generated_code = Team.generate_team_code
        @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 2)     
        @bob.teams << @team
        @feedback = Feedback.new(rating: 10, communication:1, collaboration:2, team_support:3, responsibility:4, work_quality:5, comments: "This comment is a test", priority: 0, collab_comment: "", communication_comment: "", team_support_comment: "", responsibility_comment: "This is a test comment", work_quality_comment: "")
        datetime = Time.current
        @feedback.timestamp = @feedback.format_time(datetime)
        @feedback.team = @bob.teams.first
        @bob.feedbacks << @feedback
    
    end

    def test_student_hist_feedback_displayed
        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        visit users_url
        assert_current_path users_url
        click_on "Bob Smith"
        assert_current_path user_path(@bob)
        assert_text "10.0"
        assert_text "1"
        assert_text "2"
        assert_text "3"
        assert_text "4: This is a test comment"
        assert_text "5"
    end    
end