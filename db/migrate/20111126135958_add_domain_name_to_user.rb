class AddDomainNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :domain_name, :string
  end
end
