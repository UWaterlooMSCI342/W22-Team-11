class AddRespondedToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :responded, :boolean, :default => false
  end
end
