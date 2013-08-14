class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.references :user, index: true

      t.timestamps
    end
  end
end
