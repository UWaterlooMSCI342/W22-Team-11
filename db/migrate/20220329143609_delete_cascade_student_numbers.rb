class DeleteCascadeStudentNumbers < ActiveRecord::Migration[6.1]
  def change
    # add cascading delete to student numbers
    remove_foreign_key :student_numbers, :users
    add_foreign_key :student_numbers, :users, on_delete: :cascade
  end
end
