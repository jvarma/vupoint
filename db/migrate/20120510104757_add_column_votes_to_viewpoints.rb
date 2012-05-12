class AddColumnVotesToViewpoints < ActiveRecord::Migration
  def change
    add_column :viewpoints, :votes, :integer, default: 0
  end
end
