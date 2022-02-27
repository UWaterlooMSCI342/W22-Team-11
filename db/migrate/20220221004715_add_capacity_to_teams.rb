class AddCapacityToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :capacity, :integer, null: false

  end
end
