class AddCommentsToFeedbacks < ActiveRecord::Migration[6.1]
  def change
    add_column :feedbacks, :collab_comment, :string, :limit => 2048
    add_column :feedbacks, :communication_comment, :string, :limit => 2048
    add_column :feedbacks, :team_support_comment, :string, :limit => 2048
    add_column :feedbacks, :responsibility_comment, :string, :limit => 2048
    add_column :feedbacks, :work_quality_comment, :string, :limit => 2048
  end
end
