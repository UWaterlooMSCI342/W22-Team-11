require "application_system_test_case"

# 1)As a user, I should be able to view all validation error messages when a form is completed incorrectly

class DisplayErrorsValidationsTest < ApplicationSystemTestCase
  setup do
    Option.create(reports_toggled: true)
    # create prof, team, and user
    @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     
  end
  #Login errors
  def test_invalid_login 
    visit root_url 
    login 'msmucker@gmail.com', 'testing'
    
    assert_text "Cannot log you in. Invalid email or password."
  end 
  #User signup errors 
  def test_invalid_signup
    visit root_url
    click_on "Sign Up"

    fill_in "user[first_name]", with: "Scott"
    fill_in "user[last_name]", with: "Smith"
    fill_in "user[team_code]", with: "TEAM01"
    fill_in "user[email]", with: "SCOTTF@gmail.com"
    fill_in "user[password]", with: "testpassword"
    fill_in "user[password_confirmation]", with: "testpassword"
    click_on "Create account"
      
    assert_text "1 error prohibited this user from being saved:"
    assert_text "Teams code does not exist"
  end
   
  def test_blank_user_signup
    visit root_url
    click_on "Sign Up"  
      
    click_on "Create account"
    assert_text "8 errors prohibited this user from being saved:"
    assert_text "Password can't be blank"
    assert_text "Password is too short (minimum is 6 characters)"
    assert_text "Email can't be blank"
    assert_text "Email is invalid"
    assert_text "First name can't be blank"
    assert_text "Last name can't be blank"
    assert_text "Password confirmation can't be blank"
    assert_text "Teams cannot be blank"
  end
  #Team signup errors 
  def test_invalid_team_signup
    visit root_url 
    login 'msmucker@gmail.com', 'professor'
    assert_current_path root_url
      
    click_on "Manage Teams"
    find('#new-team-link').click
    #blank team_name
    fill_in "Team code", with: "Code 1"
    click_on "Create Team"
      
    assert_text "3 errors prohibited this team from being saved:"
    assert_text "Team name can't be blank"
    
  end
  # Feedback errors
  def test_invalid_feedback_1
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
      
    click_on "Submit for"
    # select "Urgent", :from => "Priority"
    click_on "Create Feedback"
      
    assert_text "You have not filled out the required fields."
  end

  def test_invalid_feedback_2
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    # select "Urgent", :from => "Priority"
    click_on "Create Feedback"
      
    assert_text "You have not filled out the required fields."
  end

  def test_invalid_feedback_with_rating_one_for_communication
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    choose('feedback_communication_1')
    click_on "Create Feedback"
    assert_text "Can not give rating of one without explanation."
  end

  def test_invalid_feedback_with_rating_one_for_collaboration
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    choose('feedback_collaboration_1')
    click_on "Create Feedback"
    assert_text "Can not give rating of one without explanation."
  end

  def test_invalid_feedback_with_rating_one_for_responsibility
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    choose('feedback_responsibility_1')
    click_on "Create Feedback"
    assert_text "Can not give rating of one without explanation."
  end

  def test_invalid_feedback_with_rating_one_for_team_support
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    choose('feedback_team_support_1')
    click_on "Create Feedback"
    assert_text "Can not give rating of one without explanation."
  end

  def test_invalid_feedback_with_rating_one_for_work_quality
    travel_to Time.new(2022, 03, 16, 06, 04, 44)
    visit root_url 
    login 'charles2@gmail.com', 'banana'
    assert_current_path root_url
    
    
    click_on "Submit for"
    assert_current_path new_feedback_url
    choose('feedback_work_quality_1')
    click_on "Create Feedback"
    assert_text "Can not give rating of one without explanation."
  end  
end
