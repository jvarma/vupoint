class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :debate_id
      t.integer :user_id

      t.timestamps
    end
    add_index :participations, :debate_id
    add_index :participations, :user_id
  end
end
