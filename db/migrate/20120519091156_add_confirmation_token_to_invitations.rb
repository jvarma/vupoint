class AddConfirmationTokenToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :confirmation_token, :string
  end
end
