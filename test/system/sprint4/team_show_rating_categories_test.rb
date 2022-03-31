require "application_system_test_case"

# Acceptance Criteria:
# 1. When on a team's show page, the columns for the user feedback entries should include 'Collaboration and Engagement', 'Communication', 'Team Support', 'Responsibility', 'Work Quality'
# 2. If a feedback category, such as 'Communication' has a comment, both the rating and comment for that category should be displayed

class TeamShowRatingCategoriesTest < ApplicationSystemTestCase
    setup do
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

    def test_team_show_rating
        visit root_url
        login 'msmucker@gmail.com','professor'
        assert_current_path root_url
        click_on "Manage Teams"
        assert_current_path teams_path

        click_on "Test Team"
        assert_current_path "/teams/#{@team.id}"
        assert_text "Collaboration and Engagement"
        assert_text "Communication"
        assert_text "Work Quality"
        assert_text "Responsibility"
        assert_text "Team Support"
        assert_text "This is a test comment"
    end


end