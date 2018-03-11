class RemoveRelativeIdFromMessages < ActiveRecord::Migration[5.1]
  def change
    remove_column :messages, :relative_id, :integer
  end
end
