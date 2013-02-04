class AddShareHashToShares < ActiveRecord::Migration
  def change
    add_column :shares, :hash_string, :string
  end
end
