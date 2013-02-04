class AddShareIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :share_id, :integer
    add_index :items, :share_id
  end
end
