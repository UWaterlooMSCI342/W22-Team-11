class AddLastNameToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :last_name, :null => false
      t.rename :name, :first_name
    end
  end
end
