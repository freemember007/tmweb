class ShareController < ApplicationController
  
  skip_before_filter :authenticate_user!, :only => [:show]
  
  def index
  end

  def show
    share = Share.find_by_hash_string params[:id]
    @items = share.items.reverse if share
  end
  
  def new
    if params[:type] == "day"
      items = current_user.items.from_day(params[:year], params[:month], params[:day])
      now = DateTime.now
      share_hash = "#{now.year}#{now.month}#{now.day}#{now.hour}#{now.minute}#{now.second}_#{SecureRandom.hex(10)}"
      share = Share.create({:user => current_user, :items => items, :hash_string => share_hash})
      @url = share_url(share_hash)
      render :json => {:success => true, :url => @url, :share_id => share.id}
    else
      item = Item.find params[:item_id]
      now = DateTime.now
      share_hash = "#{now.year}#{now.month}#{now.day}#{now.hour}#{now.minute}#{now.second}_#{SecureRandom.hex(10)}"
      share = Share.create({:user => current_user, :items => [item], :hash_string => share_hash})
      @url = share_url(share_hash)
      render :json => {:success => true, :url => @url, :share_id => share.id}
    end
  end
  
  def create
    
  end

end
