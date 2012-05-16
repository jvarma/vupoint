class CreateDebateInvites < ActiveRecord::Migration
  def change
    create_table :debate_invites do |t|
      t.integer :sender_id
      t.integer :debate_id
      t.integer :receiver_id
      t.string :email
      t.text :message

      t.timestamps
    end
  end
end
