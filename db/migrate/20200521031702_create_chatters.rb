class CreateChatters < ActiveRecord::Migration[6.0]
  def change
    create_table :chatters do |t|
      t.string :facebook_sender_id, index: true
      t.string :state

      t.timestamps
    end
  end
end
