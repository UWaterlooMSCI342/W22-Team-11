require "application_system_test_case"

# Acceptance Criteria:
# 1. As student, I should be able to see the time I have started a feedback
# 2. As a student, I should be able to see the time that I have submitted a feedback

class FeebackTimeDisplayTest < ApplicationSystemTestCase
  setup do
    @user = User.new(email: 'test@gmail.com', password: 'asdasd', password_confirmation: 'asdasd', first_name: 'Zac', last_name: 'Smith', is_admin: false)
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    @team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: @prof, capacity: 5)
    @user.teams << @team
    @user.save
      
    # Time.zone = 'Pacific Time (US & Canada)'

    datetime =  Time.zone.parse("2021-3-21 23:30:00")
    feedback_time = Time.zone.parse("2021-3-20 23:30:00")
    travel_to datetime
  end 
    
  def test_time_displays
      
    travel_to Time.new(2022, 03, 16, 06, 04, 0)

    visit root_url
    login 'test@gmail.com', 'asdasd'
    assert_current_path root_url
    
    click_on "Submit for"
    assert_text "Current System Time: 2022/03/16 06:04" #Acceptance criteria #1
    choose('feedback_communication_5')
    choose('feedback_team_support_5')
    choose('feedback_collaboration_5')
    choose('feedback_responsibility_5')
    choose('feedback_work_quality_5')
    select "None", :from => "feedback_priority"
    click_on "Create Feedback"
    assert_current_path root_url
    assert_text "Feedback was successfully created. Time created: 2022/03/16 6:04:00" #Acceptance criteria #2
  end 
  
end