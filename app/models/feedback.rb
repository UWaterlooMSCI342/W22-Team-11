class Feedback < ApplicationRecord
  belongs_to :user
  belongs_to :team

  #requires feedback to have at minimal a rating score, comments are optional 
  validates_presence_of :communication
  validates_presence_of :responsibility
  validates_presence_of :work_quality
  validates_presence_of :team_support
  validates_presence_of :collaboration
  
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
  
  # # takes list of feedbacks and returns average rating
  #def self.average_rating(feedbacks)
   #  (feedbacks.sum{|feedback| feedback.rating.to_f}/feedbacks.count.to_f).round(2)
  #end

  def self.show_converted_average(feedbacks)
    (feedbacks.sum{|feedback| feedback.converted_rating.to_f}/feedbacks.count.to_f).round(2)
  end

  # function inspired by https://stackoverflow.com/questions/929103/convert-a-number-range-to-another-range-maintaining-ratio
  def converted_rating

    # weights of all feedback types, with 1.0 representing standard weight
    communication_weighted = communication * 1.0
    responsibility_weighted = responsibility * 1.0
    work_quality_weighted = work_quality * 1.0
    team_support_weighted = team_support * 1.0
    collaboration_weighted = collaboration * 1.0

    # sum of feedback types
    total_feedback = communication_weighted + responsibility_weighted + work_quality_weighted + team_support_weighted + collaboration_weighted

    # CURRENT feedback scale for sum of feedback types, can change if one or more feedback type(s) scales changes (in the view)
    # 5 questions, each max being 5, 5*5 = 25
    feedbackMaxTotal = 25.0
    # 5 questions, each min being 1, 5*1 = 5
    feedbackMinTotal = 5.0
    feedbackRange = (feedbackMaxTotal - feedbackMinTotal)  

    # rating scale, that client wants
    ratingMax = 10.0
    ratingMin = 1.0
    ratingRange = (ratingMax - ratingMin) 

    # feedback scale to rating scale
    converted_rating = (((total_feedback - feedbackMinTotal) * ratingRange) / feedbackRange) + ratingMin

    return converted_rating
  end

 # global variables for order_by function
  @@reverse_order_team = false
  @@reverse_order_count = "ASC"
  @@reverse_order_time = false
  @@reverse_order_priority = false
  @@reverse_order_student_name = false
  
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
      # no reverse order because it's more useful to see teams with low ratings at the start of the list
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
      if @@reverse_order_student_name = false
        @@reverse_order_student_name = true
        return Feedback.includes(:user).order("users.first_name")
      else
        @@reverse_order_student_name = false
        return Feedback.includes(:user).order("users.first_name").reverse_order
      end
    else
      return Feedback.order('timestamp DESC')   
    end
  end 
end
