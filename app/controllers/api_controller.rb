class ApiController < ApplicationController
  skip_before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token
  
  def login
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      data = []
      lastday = u.items.first.created_at
      Rails.logger.info u.items.first
      Rails.logger.info lastday
      @items = u.items.from_month(lastday.year, lastday.month).group_by{|item| item.created_at.to_date }
      render :json => {:type => :success, :id => u.id, :email => params[:email], :password => params[:password], :items => @items}
      return
    else
      render :json => {:type => :fail}
      return
    end
  end
  
  def login_bak
    u = User.find_for_database_authentication(:email=>params[:email])
    if u.nil?
      render :json => {:type => :fail}
      return
    end
    if u.valid_password?(params[:password])
      data = []
      lastday = u.items.first.created_at
      Rails.logger.info u.items.first
      Rails.logger.info lastday
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
    item.save
    img = Image.create({:url => "#{root_url[0, root_url.length - 1]}#{item.photo_url}", :item => item})
    pp img 
    puts DateTime.now
    content = "null"
    content = item.content if !item.content.nil? && item.content.length > 0
    
    render :json => {:type => :success, :item => {
        :image => item.url, :content => content, :month => item.created_at.month, :day => item.created_at.day
    }}
  end
  
  def publish_blog
    user = User.find_by_id params[:id]
    item = Item.create({:content => params[:content], :user => user})
    
    render :json => {:type => :success, :item => {
        :image => "null", :content => item.content, :month => item.created_at.month, :day => item.created_at.day
    }}
  end

end
