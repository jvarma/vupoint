class AddIndexToUsersConfirmationToken < ActiveRecord::Migration
  def change
  	add_index :users, :confirmation_token
  end
end
