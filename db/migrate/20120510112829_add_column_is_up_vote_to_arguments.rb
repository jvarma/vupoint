class AddColumnIsUpVoteToArguments < ActiveRecord::Migration
  def change
    add_column :arguments, :is_up_vote, :boolean, default: true
  end
end
