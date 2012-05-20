class AddIndexConfirmationTokenInvitations < ActiveRecord::Migration
  def change
  	add_index :invitations, :confirmation_token
  end
end
