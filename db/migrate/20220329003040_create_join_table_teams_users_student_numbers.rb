class CreateJoinTableTeamsUsersStudentNumbers < ActiveRecord::Migration[6.1]
  def change
    create_join_table :teams_users, :student_numbers do |t|
      # t.index [:teams_user_id, :student_number_id]
      t.index [:student_number_id, :teams_user_id], unique: true, name: 'index_student_numbers_teams_users'
    end
  end
end
