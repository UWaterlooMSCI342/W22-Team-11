class ChangeFeedbacksRating < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:feedbacks, :rating, true)
  end
end
