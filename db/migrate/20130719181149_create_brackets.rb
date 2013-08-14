class CreateBrackets < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.string :name
      t.references :winner, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
