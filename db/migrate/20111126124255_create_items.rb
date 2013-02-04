class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.text :content
      t.belongs_to :user

      t.timestamps
    end
    add_index :items, :user_id
  end
end
