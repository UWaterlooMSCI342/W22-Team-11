require "application_system_test_case"


class DeleteFeedbackTest < ApplicationSystemTestCase
  setup do 
    @prof = User.new(email: 'msmucker@gmail.com', password: 'professor', password_confirmation: 'professor', first_name: 'Mark', last_name: 'Smith',  is_admin: true)
    @prof.save
    @user = User.new(email: 'adam@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'Adam', last_name: 'Smith', is_admin: false)
    @user.save

    @team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    @team.user = @prof
    @team.save
    @user.teams << @team

    #create new feedback from student with comment and priority of 2 (low)
    @feedback = Feedback.new(collaboration: 5, communication: 5, team_support: 5, responsibility:5, work_quality:5, comments: 'This team is disorganized', priority: 2)
    @feedback.timestamp = @feedback.format_time(DateTime.now)
    @feedback.user = @user
    @feedback.team = @user.teams.first
    @feedback.rating = @feedback.converted_rating
    @feedback.save
  end 
  
  def test_delete_feedback
    visit root_url
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
    click_on "Feedback & Ratings"
    assert_text "This team is disorganized"
    click_on "Delete Feedback"
    assert_no_text "This team is disorganized"
    assert_text "Feedback was successfully destroyed."
  end 

  # removed edit feedback feature
  #def test_edit_feedback
    #visit root_url
    #login 'msmucker@gmail.com', 'professor'
    #assert_current_path root_url
    #click_on "Feedback & Ratings"
    #click_on "Edit"
    #choose('feedback_team_support_3')
    #fill_in "General Comments", with: "New Comment"
    #click_on "Update Feedback"
    #assert_text "New Comment"
 # end
end
