class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :url
      t.belongs_to :item

      t.timestamps
    end
    add_index :images, :item_id
  end
end
