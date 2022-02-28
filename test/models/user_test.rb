require 'test_helper'
require 'minitest/autorun'

class UserTest < ActiveSupport::TestCase

   def setup 
    @user = User.create(email: 'scott@gmail.com', password: 'password', password_confirmation: 'password', first_name: 'Scott', last_name: 'A' ,is_admin: false)
    @prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: true)
   end
    
  def test_role_function_professor
    professor = User.new(email: 'azina@gmail.com', password: 'password', password_confirmation: 'password', first_name: 'Azin', last_name: 'Smith', is_admin: true) 
    assert_equal('Professor', professor.role)
  end 
  
  def test_role_function_student 
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false)
    assert_equal('Student', user1.role)
  end 
  
  def test_team_names 
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.user = @prof 
    team2.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false, teams: [team, team2])
    assert_equal(['Team 1', 'Team 2'], user1.team_names)
  end
  
  def test_one_submission_no_submissions
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false, teams: [team])
    assert_equal([], user1.one_submission_teams)
  end
  
  def test_one_submission_existing_submissions 
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false, teams: [team])
    feedback = Feedback.new(collaboration: 4, communication: 4, team_support: 3, responsibility: 2, work_quality:5 , comments: "This team is disorganized")
    feedback.timestamp = feedback.format_time(Time.zone.now)
    feedback.user = user1
    feedback.team = team
    feedback.save! 
    
    assert_equal([team], user1.one_submission_teams)
  end
  
  # 1) As a user, I cannot create an account with a duplicate email
  test 'valid signup' do
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false, teams: [team])
    assert user1.valid?

  end
    
  #test that two professors can signup
  test 'valid prof signup' do
     professor = User.new(email: 'azina@gmail.com', password: 'password', password_confirmation: 'password', first_name: 'Azin', last_name: 'Smith', is_admin: true) 
     assert professor.valid?
  end
  
  test 'invalid signup without unique email' do
      user1 = User.new(email: 'scott@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Scott', last_name: 'F', is_admin: false)
      refute user1.valid?, 'user must have unique email'
      assert_not_nil user1.errors[:email]
  end
    
  # 4) As a user, I cannot create an account with a password less than 6 characters
  test 'invalid signup password' do
      user1 = User.new(email: 'scottf@gmail.com', password: 'apple', password_confirmation: 'apple', first_name: 'Scott', last_name: 'F', is_admin: false)
      refute user1.valid?, 'user password must have at least 6 characters'
      assert_not_nil user1.errors[:password]
  end
  
  #name is too long
  test 'invalid signup first name' do
      user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', last_name: 'Smith', is_admin: false)
      refute user1.valid?, 'user first name must have less than 40 characters'
      assert_not_nil user1.errors[:first_name]
  end

  def test_invalid_signup_last_name 
    user1 = User.new(email: 'scottf@gmail.com', password: 'banana', password_confirmation: 'banana', last_name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', first_name: 'Smith', is_admin: false)
      refute user1.valid?, 'user last name must have less than 40 characters'
      assert_not_nil user1.errors[:last_name]
  end

  # As a student, I should be able to see the number of days until a weekly rating is due,
  # and I should only see that if there are ratings due.
  def test_rating_reminders
    user = User.new(email: 'charles42@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
    user.save!

    team = Team.new(team_name: 'Hello World', team_code: 'Code', user: user, capacity: 5)
    team.save!
    team2 = Team.new(team_name: 'Team Name', team_code: 'Code2', user: user, capacity: 5)
    team2.save!
    user.teams << [team, team2]
    user.save!
    reminders = user.rating_reminders
    assert_equal reminders.size, 2

    # create feeedback for team
    datetime = Time.zone.now
    feedback = Feedback.new(collaboration: 4, communication: 4, team_support: 3, responsibility: 2, work_quality:5 , comments: "This team is disorganized")
    feedback.timestamp = feedback.format_time(datetime)
    feedback.user = user
    feedback.team = team
    feedback.save! 

    # ensure that feedback created in previous week does not stop warning from displaying 
    datetime2 = DateTime.new(1990,2,3)
    feedback2 = Feedback.new(collaboration: 4, communication: 4, team_support: 3, responsibility: 2, work_quality:5, comments: "This team is disorganized")
    feedback2.timestamp = feedback2.format_time(datetime2)
    feedback2.user = user
    feedback2.team = team2
    feedback2.save!
    array = user.rating_reminders
    array = array.map { |team| team.team_name }
    assert_equal true, array.include?("Team Name")
    assert_equal 1, array.size
  end

  def test_reset_pass_method_changes_password
    old_password = 'testpassword'
    bob = User.new(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: old_password, password_confirmation: old_password)
    bob.save!
    new_password = 'newpassword'
    bob.reset_pass(new_password)
    assert(bob.password != old_password)
  end

  def test_reset_pass_method_sets_new_pass
    bob = User.new(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    bob.save!
    new_password = 'newpassword'
    bob.reset_pass(new_password)
    assert(bob.password == new_password)
  end

  def test_generate_random_pass_method_length
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    random_password = @bob.generate_random_pass(10)
    assert(random_password.length == 10)
  end

  def test_generate_random_pass_method_length_2
    @bob = User.create(email: 'bob@gmail.com', first_name: 'Bob', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
    random_password = @bob.generate_random_pass(7)
    assert(random_password.length == 7)
  end
  
end
