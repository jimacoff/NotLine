class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :content
      t.integer :relative_id
      t.integer :chat_id
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
