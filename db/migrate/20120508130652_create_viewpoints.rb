class CreateViewpoints < ActiveRecord::Migration
  def change
    create_table :viewpoints do |t|
      t.string :desc
      t.integer :debate_id

      t.timestamps
    end
    add_index :viewpoints, :debate_id
  end
end
