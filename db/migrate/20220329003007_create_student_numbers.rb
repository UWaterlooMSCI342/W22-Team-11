class CreateStudentNumbers < ActiveRecord::Migration[6.1]
  def change
    create_table :student_numbers do |t|
      t.string :number, limit: 8
      t.references :team, null: false, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :student_numbers, :number, unique: true
  end
end
