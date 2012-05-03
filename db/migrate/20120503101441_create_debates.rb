class CreateDebates < ActiveRecord::Migration
  def change
    create_table :debates do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :debates, [:user_id, :created_at]
  end
end
