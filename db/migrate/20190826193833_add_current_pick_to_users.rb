class AddCurrentPickToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_pick, :string
  end
end
