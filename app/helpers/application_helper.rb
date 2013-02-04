module ApplicationHelper
  
  def am_pm date
    hour = date.strftime("%H").to_i
    am_pm = ""
    if hour < 9
      am_pm = t("time.qingchen")
    elsif hour < 12
      am_pm = t("time.shangwu")
    elsif hour < 14
      am_pm = t("time.zhongwu")
    elsif hour < 18
      am_pm = t("time.xiawu")
    elsif hour < 21
      am_pm = t("time.huanghun")
    elsif hour < 24
      am_pm = t("time.shenye")
    end
    am_pm
  end
  
end
