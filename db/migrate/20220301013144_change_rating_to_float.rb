class ChangeRatingToFloat < ActiveRecord::Migration[6.1]
  def change
    change_column(:feedbacks, :rating, :decimal)
  end
end
