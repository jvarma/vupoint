class AddColumnUserIdToViewpoints < ActiveRecord::Migration
  def change
    add_column :viewpoints, :user_id, :integer
  end
end
