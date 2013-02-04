class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|

      t.timestamps
    end
  end
end
