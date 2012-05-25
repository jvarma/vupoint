class CreateInvitationRequests < ActiveRecord::Migration
  def change
    create_table :invitation_requests do |t|
      t.string :name
      t.string :email
      t.string :city
      t.string :country

      t.timestamps
    end
    add_index :invitation_requests, :email
  end
end
