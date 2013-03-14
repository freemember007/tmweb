class Item < ActiveRecord::Base

  has_many :images
  belongs_to :user
  belongs_to :share
  
  mount_uploader :photo, PhotoUploader
  
  default_scope order("created_at DESC")
  
  # Recent items which are taken in the last 3 days
  scope :recent, lambda{ limit(5) }
  
  scope :recent10, lambda{ limit(10) }
  
  scope :random, lambda{ |firstID|
    a = (1...firstID).to_a
    ids = a.sample(50)
    ids = "(" + ids.join(",") + ")"
    find_by_sql("select * from items where id in " + ids)
  }
  # Specific year items
  scope :from_year, lambda{ |year|
    year = Date.new(year.to_i)
    beginning_of_year = year.beginning_of_year
    end_of_year = year.end_of_year
    where("created_at >= :start AND created_at <= :end", :start => beginning_of_year, :end => end_of_year)
  }
  
  # Specific month items
  scope :from_month, lambda{ |year, month|
    month = DateTime.new(year.to_i, month.to_i)
    beginning_of_month = month.beginning_of_month
    end_of_month = month.end_of_month
    from_year(year).where("created_at >= :start AND created_at <= :end", :start => beginning_of_month, :end => end_of_month)
  }
  
  # Specific day items
  scope :from_day, lambda{ |year, month, day| 
    day = DateTime.new(year.to_i, month.to_i, day.to_i)
    beginning_of_day = day.beginning_of_day
    end_of_day = day.end_of_day
    from_month(year, month).where("created_at >= :start AND created_at <= :end", :start => beginning_of_day, :end => end_of_day)
  }
  
  # I dont know, but it does not work
  scope :group_by_month, lambda{ |year|
    from_year(year).group_by{|item| item.created_at.month }
  }
  
  scope :group_by_day, lambda{ |year, month|
    from_month(year, month).group_by{|item| item.created_at.day }
  }
  
  # Public items
  scope :public_items, lambda{ where("pulish_type = ?", "public") }
  
  # Private items
  scope :private_items, lambda{ where("publish_type = ?", "private") }

end
