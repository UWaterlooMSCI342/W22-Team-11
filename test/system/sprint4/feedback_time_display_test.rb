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
      


    visit root_url
    login 'test@gmail.com', 'asdasd'
    assert_current_path root_url
    
    click_on "Submit for"
    assert_text "Current System Time: 2021/03/21 23:30" #Acceptance criteria #1
    find(:xpath, "//*[@id='feedback_collaboration']").set 5
    find(:xpath, "//*[@id='feedback_communication']").set 4
    find(:xpath, "//*[@id='feedback_team_support']").set 3
    find(:xpath, "//*[@id='feedback_responsibility']").set 2
    find(:xpath, "//*[@id='feedback_work_quality']").set 1
    select "Urgent", :from => "Priority"
    click_on "Create Feedback"
    assert_current_path root_url
    assert_text "Feedback was successfully created. Time created: 2021-03-21 23:30:00" #Acceptance criteria #2
  end 
  
end