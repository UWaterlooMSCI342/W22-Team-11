class AddCommunicationToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    # adding new question columns to the feedback table
    add_column :feedbacks, :communication, :integer, :null => false
    add_column :feedbacks, :responsibility, :integer, :null =>false
    add_column :feedbacks, :work_quality, :integer, :null => false
    add_column :feedbacks, :team_support, :integer, :null => false
    add_column :feedbacks, :collaboration, :integer, :null => false
  end
end
