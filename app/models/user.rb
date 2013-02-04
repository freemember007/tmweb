class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :domain_name
  
  has_many :items
  has_many :shares
  
  validates_presence_of :domain_name
  validates_uniqueness_of :domain_name
  
  def has_item? item
    items.select{|it| it.id == item.id }.any?
  end

end
