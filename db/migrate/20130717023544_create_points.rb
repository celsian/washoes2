class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.integer :score
      t.references :game_player

      t.timestamps
    end
  end
end
