require "application_system_test_case"

#Acceptance Criteria
# 1. Given that I am a new user, I am required to input my first name and last
#   name separately when I sign up.
# 2. Given that I am a new user, I should receive an error if I do not have both
#   a first and last name in the login form

class PromptUserForFirstNameLastNameValidations < ApplicationSystemTestCase
    setup do
    Option.create(reports_toggled: true)
    prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    team = Team.create(team_name: 'Test Team', team_code: 'TEAM01', user: prof, capacity: 5)
    user = User.create(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false, teams: [team])
    end
  #1) As a new user, I am required to input my first name when signing up, and will recieve an error if now
    def test_create_student_no_first_name
    # register new student
    visit root_url
    click_on "Sign Up"

    
    fill_in "user[last_name]", with: "F"
    fill_in "user[team_code]", with: "TEAM01"
    fill_in "user[email]", with: "SCOTTF@gmail.com"
    fill_in "user[password]", with: "testpassword"
    fill_in "user[password_confirmation]", with: "testpassword"
    click_on "Create account"
    assert_current_path users_url 
    assert_text "1 error prohibited this user from being saved:"
    assert_text "First name can't be blank"
    end

    # 2) as a new student I am required to input a last name when signing up, and will recieve an error if not
    def test_create_student_no_first_name
    visit root_url
    click_on "Sign Up"

    fill_in "user[first_name]", with: "Scott"
    fill_in "user[team_code]", with: "TEAM01"
    fill_in "user[email]", with: "SCOTTF1@gmail.com"
    fill_in "user[password]", with: "testpassword"
    fill_in "user[password_confirmation]", with: "testpassword"
    click_on "Create account"
    assert_current_path users_url 

    assert_text "1 error prohibited this user from being saved:"
    assert_text "Last name can't be blank"
    end
end