class ItemsController < ApplicationController

  before_filter :check_user_is_valid?
  before_filter :check_date_format_is_valid?

  def index
    if @only_year
      act_as_year
    elsif @only_month
      act_as_month
    elsif @only_day
      act_as_day
    end
  end
  
  def show
    @item = Item.find params[:id]
  end
  
  def delete
    item = Item.find params[:id]
    item.delete
    render :json => {:success => "true"}
  end
  
  private
  
    # Year index
    def act_as_year
      @year ||= Time.now.year
      @recent_items = current_user.items.recent
      @all_items = current_user.items.from_year(@year.to_i).group_by{|item| item.created_at.month }
      @image_by_month = {}
      @all_items.each do |month, items|
        images = []
        items.each do |item|
          images << [item, item]
        end
        @image_by_month[month] = images
      end
    end
    
    def act_as_month
      @month = @month.to_i
      @year = @year.to_i
      @items = current_user.items.from_month(@year, @month).group_by{|item| item.created_at.day }
      #puts @items
      @next_year = @pre_year = @year
      @next_month = @month + 1
      @pre_month = @month - 1
      
      if @month == 12
        @next_year = @year + 1
        @next_month = 1
      elsif @month == 1
        @pre_year = @year - 1
        @pre_month = 12
      end
      
      @current_date = Date.new(@year, @month)
      
      render "month"
    end
    
    def act_as_day
      @items = current_user.items.from_day(@year.to_i, @month.to_i, @day.to_i)
      @date = Date.new(@year.to_i, @month.to_i, @day.to_i)
      @pre_date = @date - 1.day
      @next_date = @date + 1.day
      render "day"
    end
    
    def check_user_is_valid?
      @domain_name = params[:domain_name]
      # redirect_to "/404.html", :status => 404 if @domain_name != current_user.domain_name
      redirect_to(root_path, :alert => "You can not brose this page") if @domain_name != current_user.domain_name
    end
    
    def check_date_format_is_valid?
      @year, @month, @day = params[:year], params[:month], params[:day]
      
      if @month.nil? and @day.nil?
        @only_year = true
      elsif @day.nil?
        @only_month = true
      elsif @day
        @only_day = true
      end
      @now = DateTime.now
    end

end
