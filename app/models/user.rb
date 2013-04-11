class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  mount_uploader :avatar, PhotoUploader
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :domain_name, :avatar, :avatar_url, :device_token #构造子属性，作用于create时。
  
  has_many :items
  has_many :shares
  has_many :p2pshares
  #has_many :p2pshares, :class_name => 'toUser', :foreign_key => "toUser_id" 
  
  validates_presence_of :domain_name
  validates_uniqueness_of :domain_name
  
  def has_item? item
    items.select{|it| it.id == item.id }.any?
  end

end
