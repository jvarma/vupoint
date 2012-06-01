class AddColumnIsPrivateToDebates < ActiveRecord::Migration
  def change
    add_column :debates, :is_private, :boolean, default: false
  end
end
