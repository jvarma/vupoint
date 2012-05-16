class AddIndexToDebateInvites < ActiveRecord::Migration
	def change
		add_index :debate_invites, :sender_id
		add_index :debate_invites, :debate_id
		add_index :debate_invites, :email
		add_index :debate_invites, [:sender_id, :debate_id, :email], unique: true
	end
end
