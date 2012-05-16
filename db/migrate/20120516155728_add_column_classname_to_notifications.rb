class AddColumnClassnameToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :classname, :string
  end
end
