class AddUploaderToUser < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string
    add_column :users, :avatar_url, :string
  end
end
