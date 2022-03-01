require "application_system_test_case"

# Acceptance Criteria: 
# 1. As a professor, I should be able to see team summary of latest period
# 2. As a professor, I should be able to see detailed team ratings 
#    for specific teams based on time periods

class FeedbackSortingTest < ApplicationSystemTestCase
  include FeedbacksHelper
  
  setup do 
    @week_range = week_range(2021, 7)
    #sets the app's date to week of Feb 15 - 21, 2021 for testing
    travel_to Time.new(2021, 02, 15, 06, 04, 44)
  end 
  
  def save_feedback(communication, collaboration, team_support, responsibility, work_quality, comments, user, timestamp, team)
    feedback = Feedback.new(collaboration: collaboration, communication: communication, team_support: team_support, responsibility:responsibility, work_quality:work_quality, comments: comments)
    feedback.user = user
    feedback.timestamp = feedback.format_time(timestamp)
    feedback.team = team
    feedback.rating = feedback.converted_rating
    feedback.save
    feedback
  end 
  
  # (1)
  def test_team_summary_by_period
    prof = User.create(email: 'msmucker@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Mark', last_name: 'Smucker', is_admin: true)
    user1 = User.create(email: 'charles2@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles1', last_name: 'Smith', is_admin: false)
    user1.save!
    user2 = User.create(email: 'charles3@gmail.com', password: 'banana', password_confirmation: 'banana', first_name: 'Charles2', last_name: 'Smith', is_admin: false)
    user2.save!
    team = Team.new(team_code: 'Code', team_name: 'Team 1', capacity: 5)
    team.user = prof 
    team.save!
    
    feedback1 = save_feedback(1, 2, 3, 4, 5, "Data1", user1, DateTime.civil_from_format(:local, 2021, 02, 15), team)
    feedback2 = save_feedback(1, 2, 3, 4, 5, "Data2", user2, DateTime.civil_from_format(:local, 2021, 02, 16), team)
    
    average_rating = ((5+6).to_f/2).round(2)
    
    visit root_url 
    login 'msmucker@gmail.com', 'banana'
    assert_current_path root_url 
    
    click_on 'Feedback & Ratings'
    click_on 'Team'
    assert_text 'Team 1'

    visit feedbacks_url
  end 
end