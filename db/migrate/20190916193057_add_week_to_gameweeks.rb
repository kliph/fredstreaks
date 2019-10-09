class AddWeekToGameweeks < ActiveRecord::Migration[5.2]
  def change
    add_column :gameweeks, :week, :integer
  end
end
