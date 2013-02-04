class AddPublishTypeToItem < ActiveRecord::Migration
  def change
    add_column :items, :publish_type, :string, :default => "private"
  end
end
