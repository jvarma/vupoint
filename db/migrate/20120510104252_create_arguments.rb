class CreateArguments < ActiveRecord::Migration
  def change
    create_table :arguments do |t|
      t.text :content
      t.integer :user_id
      t.integer :viewpoint_id

      t.timestamps
    end
    add_index :arguments, :user_id
    add_index :arguments, :viewpoint_id
  end
end
