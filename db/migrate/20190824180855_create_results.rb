class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.references :user, foreign_key: true
      t.string :pick
      t.references :gameweek, foreign_key: true
      t.date :date
      t.integer :points

      t.timestamps
    end
  end
end
