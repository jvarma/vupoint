class AddColumnUnknownObjectIdToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :unknown_object_id, :integer
  end
end
