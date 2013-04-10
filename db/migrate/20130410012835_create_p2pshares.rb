class CreateP2pshares < ActiveRecord::Migration
  def change
    create_table :p2pshares do |t|
      t.belongs_to :item
      t.belongs_to :user

      t.timestamps
    end
    add_index :p2pshares, :item_id
    add_index :p2pshares, :user_id
  end
end
