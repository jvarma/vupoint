class AddIndexOnUserIdToViewpoints < ActiveRecord::Migration
  def change
  	add_index :viewpoints, :user_id
  end
end
