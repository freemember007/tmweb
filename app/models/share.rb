class Share < ActiveRecord::Base
  
  belongs_to :user
  has_many :items
  
  scope :by_hash_string, lambda{|hash_string| where(:hash_string => hash_string) }
  
end
