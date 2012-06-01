class CreateJoinRequests < ActiveRecord::Migration
  def change
    create_table :join_requests do |t|
      t.integer :debate_id
      t.integer :user_id

      t.timestamps
    end
    add_index :join_requests, :debate_id
    add_index :join_requests, :user_id
  end
end
