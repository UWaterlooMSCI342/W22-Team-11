class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :team

  #requires feedback to have at minimal a rating score, comments are optional 
  validates_presence_of :communication, :responsibility, :work_quality, :team_support, :collaboration
  #allows a max of 2048 characters for additional comments
  validates_length_of :comments, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  validates_length_of :collab_comment, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  validates_length_of :communication_comment, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  validates_length_of :team_support_comment, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  validates_length_of :responsibility_comment, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  validates_length_of :work_quality_comment, :maximum => 2048, :message => "Please limit your comment to 2048 characters or less!"
  def format_time(given_date)
  #refomats the UTC time in terms if YYYY/MM?DD HH:MM
      #current_time = given_date.in_time_zone('Eastern Time (US & Canada)').strftime('%Y/%m/%d %H:%M')
      current_time = given_date.strftime('%Y/%m/%d %H:%M')
      return current_time
  end
  
  # takes list of feedbacks and returns average rating
  def self.average_rating(feedbacks)
    (feedbacks.sum{|feedback| feedback.rating}.to_f/feedbacks.count.to_f).round(2)
  end

  @@reverse_order_team = false
  @@reverse_order_count = "ASC"

  @@reverse_order_time = false

  @@reverse_order_priority = false
  
  # ordering feedback based on attribute
#  def self.order_by field
#    if field == 'team'
#      return Feedback.includes(:team).order("teams.team_name")
#    else
#      return Feedback.order('timestamp DESC')
#    end
#  end

  def self.order_by field
    if field == 'team'
      if @@reverse_order_team == false
        @@reverse_order_team = true
        return Feedback.includes(:team).order("teams.team_name")
      else
        @@reverse_order_team = false
        return Feedback.includes(:team).order("teams.team_name").reverse_order
      end
    elsif field == 'timestamp'
      if @@reverse_order_time == false
        @@reverse_order_time = true
        return Feedback.order('timestamp')
      else
        @@reverse_order_time = false
        return Feedback.order('timestamp').reverse_order
      end
    elsif field == 'rating'
      return Feedback.order(:rating, :timestamp)
    elsif field =='priority'
      if @@reverse_order_priority == false
        @@reverse_order_priority = true
        return Feedback.order(:priority, :timestamp)
      else
        @@reverse_order_priority = false
        return Feedback.order(:priority, :timestamp).reverse_order
      end
    elsif field == 'student name'
      return Feedback.includes(:user).order("users.name")
    else
      return Feedback.order('timestamp DESC')   
    end
  end 
end



