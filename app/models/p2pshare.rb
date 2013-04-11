class P2pshare < ActiveRecord::Base
  belongs_to :item
  belongs_to :user
  #belongs_to :user,  :class_name => 'toUser', :foreign_key => "toUser_id" 
  
  default_scope order("created_at DESC")
  
  scope :recent, lambda{ limit(10) }
  
end
