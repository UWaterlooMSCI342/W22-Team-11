require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  def login(email, password)
    assert_current_path login_url
    fill_in "Email", with: email
    fill_in "Password", with: password
    click_on "Login"
  end 
  
  def save_feedback(collaboration, communication, team_support, responsibility, work_quality, comments, user, timestamp, team, priority)
    feedback = Feedback.new(collaboration: collaboration, communication: communication, team_support: team_support, responsibility:responsibility, work_quality:work_quality, comments: comments, priority: priority)
    feedback.user = user
    feedback.timestamp = feedback.format_time(timestamp)
    feedback.team = team
    feedback.rating = feedback.converted_rating
    feedback.save
    feedback
  end 
end
