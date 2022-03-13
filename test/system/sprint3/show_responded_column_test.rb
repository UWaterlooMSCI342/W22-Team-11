require "application_system_test_case"

class ShowRespondedColumnTest < ApplicationSystemTestCase
   def setup 
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @generated_code = Team.generate_team_code
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM00', user: @prof, capacity: 2)     
    @bob.teams << @team
    @feedback = Feedback.new(rating: 1, communication:1, collaboration:1, team_support:1, responsibility:1, work_quality:1, comments: "No comment", priority: 0)
    datetime = Time.current
    @feedback.timestamp = @feedback.format_time(datetime)
    @feedback.team = @bob.teams.first
    @bob.feedbacks << @feedback

    end

    def test_show_responded_column_if_low_feedback
        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        click_on "Feedback & Ratings"
        assert_current_path feedbacks_path
        click_button "Save"
    end

    def test_no_show_responded_column_if_high_feedback
        @feedback.rating = 10
        @feedback.save

        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        click_on "Feedback & Ratings"
        assert_current_path feedbacks_path
        assert_text "10.0"
        #Received inspiration from this post for using has_no_button?: https://stackoverflow.com/questions/5906039/ensure-an-element-is-not-present-with-capybara
        assert has_no_button?('Save')
        
    end

end