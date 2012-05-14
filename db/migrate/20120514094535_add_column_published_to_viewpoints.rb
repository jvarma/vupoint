class AddColumnPublishedToViewpoints < ActiveRecord::Migration
  def change
    add_column :viewpoints, :published, :boolean, default: false
  end
end
