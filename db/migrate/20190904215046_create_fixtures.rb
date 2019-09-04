class CreateFixtures < ActiveRecord::Migration[5.2]
  def change
    create_table :fixtures do |t|
      t.references :gameweek, foreign_key: true
      t.json :matches

      t.timestamps
    end
  end
end
