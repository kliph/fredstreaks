class AddCurrentStreakToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_streak, :integer, default: 0
  end
end
