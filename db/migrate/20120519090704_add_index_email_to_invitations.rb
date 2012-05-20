class AddIndexEmailToInvitations < ActiveRecord::Migration
  def change
  	add_index :invitations, :email
  	add_index :invitations, :user_id
  end
end
