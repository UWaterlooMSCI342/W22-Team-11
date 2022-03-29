require 'test_helper'
require 'date'
class TeamTest < ActiveSupport::TestCase
    include FeedbacksHelper
    
  setup do
      @prof = User.create(email: 'charles@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: true)
  end

  def test_unique_team_code_admin
    Option.destroy_all
    Option.create(reports_toggled: true, admin_code: 'admin')
    
    team2 = Team.new(team_code: 'admin', team_name: 'Team 2', capacity: 5)
    team2.user = @prof
    assert_not team2.valid?
  end 

  def test_add_students
      # create test admin
      user = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
      user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
      

      team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 6)
      team.user = @prof
      team.users = [user, user2]
      assert_difference('Team.count', 1) do
          team.save
      end
  end

  def test_create_team_invalid_team_code
      team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
      team.user = @prof
      team.save!
      # try creating team with another team with same team code
      # test case insensitive
      team2 = Team.new(team_code: 'code', team_name: 'Team 2', capacity: 5)
      team2.user = @prof
      assert_not team2.valid?
  end

  def test_create_team_blank_team_code
      team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
      team.user = @prof
      team.save!
      # try creating team with blank code
      team2 = Team.new(team_name: 'Team 2', capacity: 5)
      team2.user = @prof
      assert_not team2.valid?
  end
  
  def test_create_team_blank_team_name
      team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
      team.user = @prof
      team.save!
      # try creating team with blank name
      team2 = Team.new(team_code: 'Code2', capacity: 5)
      team2.user = @prof
      assert_not team2.valid?
  end

  def test_create_team_invalid_capacity_negative
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: -1)
    team2.user = @prof
    assert_not team2.valid?
  end

  def test_create_team_invalid_capacity_zero
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 0)
    team2.user = @prof
    assert_not team2.valid?
  end
  
  def test_add_students_to_team
      user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
      user1.save!
      team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
      team.user = @prof
      team.save!
      assert_difference("team.users.count", + 1) do
          team.users << user1
          team.save!
      end
  end

  def test_create_user_invalid_team_duplicate
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save!
    # try creating team with another team with same team code
    team2 = Team.new(team_code: 'Code', team_name: 'Team 2', capacity: 5)
    team2.user = @prof
    assert_not team2.valid?
  end
  
  def test_create_user_invalid_team_code
    # too long of a code
    team2 = Team.new(team_code: 'qwertyuiopasdfghjklzxcvbnmq', team_name: 'Team 2', capacity: 5)
    team2.user = @prof
    assert_not team2.valid?
  end

  def test_create_user_invalid_team_name
    # too long of a name
    team2 = Team.new(team_code: 'qwerty', team_name: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', capacity: 5)
    team2.user = @prof
    assert_not team2.valid?
  end
    
  def test_add_students_to_team
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles', last_name: 'Smith', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.save!
    assert_difference("team.users.count", + 1) do
      team.users << user1
      team.save!
    end
  end

  def test_get_student_names
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.users = [user1, user2]
    team.save!

    students = team.student_names
    students.sort!
    assert_equal ['Charles1 Smith', 'Charles2 Smith'], students
  end
  
  def test_feedback_by_period_no_feedback 
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save! 
    
    assert_nil(team.feedback_by_period)
  end
  
  def test_feedback_by_period_one_period
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team.user = @prof 
    team.save!     
    
    feedback = save_feedback(5, 4, 3, 2, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(5, 4, 3, 2, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    
    periods = team.feedback_by_period 
    assert_equal({year: 2021, week: 9}, periods[0][0])
    assert_includes( periods[0][1], feedback )
    assert_includes( periods[0][1], feedback2 )
    assert_equal( 2, periods[0][1].length )
  end
  
  def test_feedback_by_period_multi_period
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team.user = @prof 
    team.save!     
    
    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 3, 3, 3, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(4, 4, 4, 4, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback4 = save_feedback(4, 3, 3, 3, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    
    periods = team.feedback_by_period 
    assert_equal({year: 2021, week: 9}, periods[0][0])
    assert_equal({year: 2021, week: 7}, periods[1][0])
    assert_includes( periods[0][1], feedback )
    assert_includes( periods[0][1], feedback2 )
    assert_includes( periods[1][1], feedback3 )
    assert_includes( periods[1][1], feedback4 )
    assert_equal( 2, periods[0][1].length )
    assert_equal( 2, periods[1][1].length )
  end
  
  def test_find_priority_weighted_team_summary_high_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof
    team.users << [user1, user2, user3]
    team.save!
    
    feedback1 = save_feedback(1, 2, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 0)
    feedback2 = save_feedback(1,1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 1)
    feedback3 = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "High", team_weighted_priority
  end
  
  def test_find_priority_weighted_team_summary_low_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.users << [user1, user2, user3]
    team.save!
    
    feedback1 = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 1)
    feedback3 = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "Low", team_weighted_priority
  end
  
  def test_find_priority_weighted_team_summary_none_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.users << [user1, user2, user3]
    team.save!
    
    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "None", team_weighted_priority
  end

  def test_find_priority_weighted_team_summary_incomplete_feedback_status
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.users << [user1, user2, user3]
    team.save!
    
    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    
    team_weighted_priority = team.find_priority_weighted(week_range[:start_date], week_range[:end_date])
    assert_equal "Missing Feedback", team_weighted_priority
  end
  
  def test_multi_feedback_average_rating_team_summary
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'adam2@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'adam3@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    user3.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(3,3, 3, 3, 3, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(3, 3, 3, 3, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(3, 3, 3, 3, 3, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 2, 17), team, 2)
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 5.5, current_week_average
  end
  
  def test_single_feedback_average_rating_team_summary_1
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 10.0, current_week_average
  end

  def test_single_feedback_average_rating_team_summary_2
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(3, 3, 3, 3, 3, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 5.5, current_week_average
  end

  def test_single_feedback_average_rating_team_summary_3
    week_range = week_range(2021, 7)
    
    user1 = User.create(email: 'adam1@gmail.com', password: '123456789', password_confirmation: '123456789', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    
    feedback1 = save_feedback(4, 4, 4, 4, 4, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    
    current_week_average = Team.feedback_average_rating(team.feedback_by_period.first[1])
    assert_equal 7.75, current_week_average
  end
  
  def test_find_priority_weighted_no_feedbacks 
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!
    
    team_weighted_priority = team.find_priority_weighted(DateTime.civil_from_format(:local, 2021, 2, 15), DateTime.civil_from_format(:local, 2021, 2, 21))
    assert_nil team_weighted_priority
  end
  
   def test_find_students_not_submitted_no_submissions
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.users = [user3]
    team2.user = @prof 
    team2.save 

    # No submissions made yet 
    assert_equal([user1, user2], team.users_not_submitted([]))
  end 

  def test_find_students_not_submitted_partial_submissions
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.users = [user3]
    team2.user = @prof 
    team2.save 

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)


    # No submissions made yet 
    assert_equal([user2], team.users_not_submitted([feedback]))

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(2, 2, 3, 3, 2, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(4, 4, 4, 3, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback4 = save_feedback(3, 4, 3, 2, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
  end

  def test_find_students_not_submitted_all_submitted
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 2, 3, 4, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2]))
  end

  def test_find_students_not_submitted_over_submitted 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)

    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!   
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 2, 3, 4, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(4, 3, 2, 3, 4, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 2), team, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2, feedback3]))
  end 

  def test_find_students_not_submitted_user_not_in_team
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!    
    team2 = Team.new(team_code: 'Code2', team_name: 'Team 2', capacity: 5)
    team2.users = [user3]
    team2.user = @prof 
    team2.save

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 4, 3, 2, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(4, 3, 4, 3, 4, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 3, 2), team2, 2)
    assert_equal([], team.users_not_submitted([feedback, feedback2, feedback3]))
  end

  def test_find_current_feedback 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(4, 3, 4, 3, 4, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)
    feedback3 = save_feedback(5, 4, 3, 4, 3, "This team is disorganized", user3, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    result = team.current_feedback(d=Date.new(2021, 3, 2))
    assert_includes( result, feedback )
    assert_includes( result, feedback2 )
    refute_includes( result, feedback3 )
    assert_equal( 2, result.length )
  end
  
  def test_generate_team_code 
    assert_equal(6, Team::generate_team_code(length = 6).size)
  end
  
  def test_status_no_users 
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = @prof 
    team.save!     

    assert_equal('white', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  #blank circle (white) for no feedback
  def test_status_no_feedback_white
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(5, 5, 5, 5, 5, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 4, 3, 2, 3, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 3), team, 2)

    assert_equal('white', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_green_status
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(3, 3, 3, 5, 5, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(5, 4, 5, 5, 4, "This team is great", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(4, 3, 3, 2, 3, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('green', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_yellow_status_rating
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana',first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 2, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 2)
    feedback2 = save_feedback(3, 3, 3, 3, 3, "This team is alright", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(4, 4, 4, 4, 5, "This team is great", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('yellow', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_yellow_status_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(4, 4, 4, 4, 4, "I think team is good, but still low urgency", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(4, 4, 4, 4, 4, "I think team is good, but still low urgency", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 1)
    feedback3 = save_feedback(5, 5, 5, 5, 5, "I think team doing great", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('yellow', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_red_status_priority
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, 1, "This team is disorganized, high urgency!", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 0)
    feedback2 = save_feedback(5, 5, 5, 4, 4, "This team is doing well, but I need high urgency!", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 0)
    feedback3 = save_feedback(5, 5, 5, 5, 5, "I think team doing great", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end
  
  def test_red_status_rating
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2]
    team.user = @prof 
    team.save!     

    feedback = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 3, 1), team, 1)
    feedback2 = save_feedback(1, 1, 1, 1, 1, "This team is disorganized", user2, DateTime.civil_from_format(:local, 2021, 3, 27), team, 2)
    feedback3 = save_feedback(3, 2, 3, 4, 3, "This team is disorganized", user1, DateTime.civil_from_format(:local, 2021, 4, 2), team, 2)
    
    assert_equal('red', team.status(DateTime.civil_from_format(:local, 2021, 3, 25), DateTime.civil_from_format(:local, 2021, 4, 3)))
  end

  def test_number_users_not_submitted_all_users_submitted
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2, user3]
    team.user = @prof 
    team.save!     

    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user3, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    
    number_users_not_submitted = team.number_users_not_submitted([feedback1, feedback2, feedback3])

    assert_equal(0, number_users_not_submitted)
  end

  def test_number_users_not_submitted_not_all_users_submitted
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam2', last_name: 'Powell', is_admin: false)
    user2.save!
    user3 = User.create(email: 'charles4@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam3', last_name: 'Powell', is_admin: false)
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.users = [user1, user2, user3]
    team.user = @prof 
    team.save!     

    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user1, DateTime.civil_from_format(:local, 2021, 2, 15), team, 2)
    feedback2 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user2, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    feedback3 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user3, DateTime.civil_from_format(:local, 2021, 2, 16), team, 2)
    
    number_users_not_submitted = team.number_users_not_submitted([feedback1, feedback2])

    assert_equal(1, number_users_not_submitted)
  end


  def test_release_feedback_not_all_submitted_not_Sunday
    date = Date.parse('10-03-2022')

    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!

    team = Team.new(team_code: 'Code', team_name: 'Team Test2', capacity: 5)
    team.users = [user1]
    team.user = @prof 
    team.save! 


    release = team.release_feedback(date)
    assert_equal(false, release)
  end

  def test_release_feedback_not_all_submitted_Sunday
    date = Date.parse('13-03-2022')

    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!

    team = Team.new(team_code: 'Code', team_name: 'Team Test3', capacity: 5)
    team.users = [user1]
    team.user = @prof 
    team.save! 


    release = team.release_feedback(date)
    assert_equal(true, release)
  end

  def test_release_feedback_before_sunday
    date = Date.parse('8-03-2022')

    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!

    team = Team.new(team_code: 'Code', team_name: 'Team Test4', capacity: 5)
    team.users = [user1]
    team.user = @prof 
    team.save! 

    feedback1 = save_feedback(5, 5, 5, 5, 5, "This team is organized", user1, DateTime.civil_from_format(:local, 2022, 3, 7), team, 2)

    release = team.release_feedback(date)
    assert_equal(true, release)
  end

  def test_auto_assign_feedback_not_Sunday
    date = Date.parse('19-03-2022')

    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!

    team = Team.new(team_code: 'Code', team_name: 'Team Test4', capacity: 5)
    team.users = [user1]
    team.user = @prof 
    team.save! 

    team.auto_assign_feedback(date)
    assert_nil(team.feedback_by_period)
  end

  def test_auto_assign_feedback_Sunday
    date = Time.new(2022, 03, 27, 06, 04, 44)
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'adam1', last_name: 'Powell', is_admin: false)
    user1.save!

    team5 = Team.new(team_code: 'Code', team_name: 'Team Test4', capacity: 5)
    team5.users = [user1]
    team5.user = @prof 
    team5.save! 

    team5.auto_assign_feedback(date)
    #period = team5.current_feedback(Date.parse('21-03-2022'))
    #week_average = Team.feedback_average_rating(team5.feedback_by_period.first[1])
    assert_equal(1, user1.feedbacks.length)
  end
  
end
