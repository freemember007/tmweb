# encoding: utf-8

class ApiController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  
  
  def login
    if params[:email].match("@")
      u = User.find_for_database_authentication(:email=>params[:email])
    else
      u = User.find_for_database_authentication(:domain_name=>params[:email])
    end
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      u.device_token = params[:device_token]
      u.save
      render :json => {:type => :success, :id => u.id, :email => u.email, :domain_name => u.domain_name, :avatar => u.avatar_url}
    else
      render :json => {:type => :fail}
    end
  end
  
  
  def register # 还需补上email与domain_name唯一性认证
    user = User.create({:email=>params[:email], :password => params[:password], :domain_name => params[:domain_name], :avatar => params[:avatar], :device_token => params[:device_token]})
    user.avatar_url = "#{root_url[0, root_url.length - 1]}#{user.avatar_url}"
    if user.save
      render :json => {:type => :success, :id => user.id, :email => user.email,  :domain_name => user.domain_name, :avatar => user.avatar_url}
    else
      render :json => {:type => :fail}
    end
  end
  
  def altAvatar
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      u.avatar = params[:avatar]
      u.avatar_url = "#{root_url[0, root_url.length - 1]}#{u.avatar_url}"
      if u.save
        render :json => {:type => :success, :avatar => u.avatar_url}
      else
        render :json => {:type => :fail}
      end
    else
      render :json => {:type => :fail}
    end
  end
  
  def userInfo
    u = User.find_for_database_authentication(:domain_name=>params[:domain_name])
    if u.nil?
      render :json => {:type => :fail}
    else
      render :json => {:type => :success, :uid => u.id, :domain_name => u.domain_name, :avatar => u.avatar_url}
    end
  end
  
  
  def delete # 有安全问题，待改进
    item = Item.find params[:id]
    item.delete
    render :json => {:type => :success}
  end
  
  
  def fetchBlog
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      offset = params[:offset]
      @items = u.items.recent10(offset).group_by{|item| item.created_at.to_date }
      render :json => {:type => :success, :items => @items}
    else
      render :json => {:type => :fail}
    end
  end
  
  def fetchMonth
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      first = u.items.first
      if first
        lastday = first.created_at 
      else
        lastday = Time.now
      end
      @items = u.items.from_month(lastday.year, lastday.month).group_by{|item| item.created_at.day }
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :items => @items}
    else
      render :json => {:type => :fail}
    end
  end
  
  
  def fetchYear
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      year ||= Time.now.year
      @all_items = u.items.from_year(year.to_i).group_by{|item| item.created_at.month }
      @items = {}
      @all_items.each do |month, items|
        items = items.group_by{|item| item.created_at.day }
        @items[:"#{month}"] = items
      end
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :items => @items}
    else
      render :json => {:type => :fail}
    end
  end
  
  def fetchRandom
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      if u.items.first
        itemsID = u.items.select('id') 
        @item = Item.find(itemsID[Random.rand(itemsID.length)])
      else
        @item = ""
      end
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :item => @item}
    else
      render :json => {:type => :fail}
    end
  end
  
  def fetchSharetome
    u = User.find(params[:id])
    p2pshares = u.p2pshares.recent # 貌似不能选ID，否则后面会出错。但多次查询，效率如何提升？ 考虑不走关系，直接按ID查询
    users = []
    items = []
    p2pshares.each do |p2pshare|
      item = p2pshare.item
      if item != nil
        items << item
        user = item.user
        users << user
      end
    end
    Rails.logger.info items
    render :json => {:type => :success, :users => users, :items => items}
  end
  
  def fetchRandom_bak
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      first = u.items.first
      if first
        firstID = first.id 
      else
        firstID = 2
      end
      @items = u.items.random(firstID)
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :items => @items}
    else
      render :json => {:type => :fail}
    end
  end
  
  
  def login_bak #先保留，有个索引(index)的东西待研究
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      data = []
      lastday = u.items.first.created_at
      Rails.logger.info u.items.first
      @items = u.items.from_month(lastday.year, lastday.month).group_by{|item| item.created_at.day }
      @items.each do |day, items|
        items.each_with_index do |item, index|
          url = "null"
          url = item.images.first.url if item.images.any?
          content = "null"
          content = item.content if !item.content.nil?
          data << {:content => content, :image => url, :date => item.created_at.strftime("%Y/%m/%d") , :index => index}
        end
      end
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :items => data}
      return
    else
      render :json => {:type => :fail}
      return
    end
  end

  
  def upload_photo
    user = User.find_by_id params[:id]
    item = Item.create({:photo => params[:photo], :content => params[:content], :user => user })
    Rails.logger.info item.photo_url
    item.url = "#{root_url[0, root_url.length - 1]}#{item.photo_url}"
    if item.save
      render :json => {:type => :success}
      img = Image.create({:url => "#{root_url[0, root_url.length - 1]}#{item.photo_url}", :item => item})
      friendsID = params[:friendsID].split(",")
      require "apns"
      APNS.host = 'gateway.sandbox.push.apple.com'
      APNS.pem =  "lib/pem/timenotePushDev.pem"
      APNS.port = 2195
      for friendID in friendsID # 不需判断friendsID是滞为空，如果friendsID为空的话，下面的都不会被执行
        p2pshare = P2pshare.create({:user_id => friendID, :item_id => item.id})
        friend = User.find_by_id friendID
        device_token = friend.device_token
        if device_token.length > 5 # 其实只是为了判断是否为空，!=nil不包括空字符，有什么更好办法？这样为nil时又会出错！
          Rails.logger.info "++++有效++++"
          APNS.send_notification(device_token, :alert => user.domain_name + '分享了一则时光给你。', :badge => 1, :sound => 'default', :other => {:sent => 'with apns gem'})
        end
      end
    else
      render :json => {:type => :fail}
    end
  end
  
  
  def publish_blog
    user = User.find_by_id params[:id]
    item = Item.create({:content => params[:content], :user => user})
    
    render :json => {:type => :success, :item => {
        :image => "null", :content => item.content, :month => item.created_at.month, :day => item.created_at.day
    }}
  end

end
