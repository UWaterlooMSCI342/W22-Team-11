class CreateStudentNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :student_numbers do |t|
      t.string :number, limit: 8
      t.references :team, null: false, foreign_key: true
      t.references :user, index: {:unique=>true}, null: true, foreign_key: true

      t.timestamps
    end
  end
end
