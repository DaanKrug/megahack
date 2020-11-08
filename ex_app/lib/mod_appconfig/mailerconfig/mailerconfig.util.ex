defmodule ExApp.MailerConfigUtil do

  alias ExApp.NumberUtil
  alias ExApp.DateUtil
  alias ExApp.StructUtil
  alias ExApp.MapUtil
  alias ExApp.UserService
  
  def markMailConfAsUsed(configs,usedPositionToSend) do
    cond do
      (usedPositionToSend >= 0) -> adjustRunUsageConfig(configs,usedPositionToSend,[],0)
      true -> configs
    end
  end
  
  defp adjustRunUsageConfig(configs,usedPosition,newConfigs,position) do
    cond do
      (position >= length(configs)) -> newConfigs
      (usedPosition == position) 
        -> adjustRunUsageConfig(configs,usedPosition,addRunUsageConfig(configs,newConfigs,position),position + 1)
      true -> adjustRunUsageConfig(configs,usedPosition,getRunUsageConfig(configs,newConfigs,position),position + 1)
    end
  end
  
  defp getRunUsageConfig(configs,newConfigs,position) do
    mailConf = StructUtil.listElementAt(configs,position)
    List.insert_at(newConfigs,length(newConfigs),mailConf)
  end
  
  defp addRunUsageConfig(configs,newConfigs,position) do
    mailConf = StructUtil.listElementAt(configs,position)
    date = Date.utc_today()
    time = Time.utc_now()
    runUsageMap = %{
      year: date.year,
      month: date.month,
      day: date.day,
      hour: time.hour,
      minute: time.minute,
      second: time.second,
      total: 1
    }
    runUsageArray = MapUtil.get(mailConf,:runUsage)
    runUsageArray = List.insert_at(runUsageArray,length(runUsageArray),runUsageMap)
    mailConf = Map.replace!(mailConf,:runUsage,runUsageArray)
    List.insert_at(newConfigs,length(newConfigs),mailConf)
  end
  
  def mailConfCanBeUsed(mailConf,ownerId,useProvisioned) do
    date = Date.utc_today()
    time = Time.utc_now()
    now = System.os_time()
    userId = NumberUtil.toInteger(MapUtil.get(mailConf,:userId))
    perMonth = NumberUtil.toInteger(MapUtil.get(mailConf,:perMonth))
    perDay = NumberUtil.toInteger(MapUtil.get(mailConf,:perDay))
    perHour = NumberUtil.toInteger(MapUtil.get(mailConf,:perHour))
    perMinute = NumberUtil.toInteger(MapUtil.get(mailConf,:perMinute))
    perSecond = NumberUtil.toInteger(MapUtil.get(mailConf,:perSecond))
    lastTimeUsed = NumberUtil.toInteger(MapUtil.get(mailConf,:lastTimeUsed))
    runUsage = MapUtil.get(mailConf,:runUsage)
    provisioned = MapUtil.get(mailConf,:provisioned)
    usedPerMonth = cond do
      DateUtil.sameMonth(lastTimeUsed,now) -> NumberUtil.toInteger(MapUtil.get(mailConf,:usedPerMonth))
      true -> 0
    end
    usedPerDay = cond do
      DateUtil.sameDay(lastTimeUsed,now) -> NumberUtil.toInteger(MapUtil.get(mailConf,:usedPerDay))
      true -> 0
    end
    usedPerHour = cond do
      DateUtil.sameHour(lastTimeUsed,now) -> NumberUtil.toInteger(MapUtil.get(mailConf,:usedPerHour))
      true -> 0
    end
    usedPerMinute = cond do
      DateUtil.sameMinute(lastTimeUsed,now) -> NumberUtil.toInteger(MapUtil.get(mailConf,:usedPerMinute))
      true -> 0
    end
    usedPerSecond = cond do
      DateUtil.sameSecond(lastTimeUsed,now) -> NumberUtil.toInteger(MapUtil.get(mailConf,:usedPerSecond))
      true -> 0
    end
    cond do
      (!(validateUseOwnerShip(ownerId,userId,provisioned,useProvisioned))) -> false
      ((usedPerMonth + calculateMontlyRunUsage(runUsage,date,0) + 1) > perMonth) -> false
      ((usedPerDay + calculateDailyRunUsage(runUsage,date,0) + 1) > perDay) -> false
      ((perHour > 0) and ((usedPerHour + calculateHourlyRunUsage(runUsage,date,time,0) + 1) > perHour)) -> false
      ((perMinute > 0) and ((usedPerMinute + calculateMinutlyRunUsage(runUsage,date,time,0) + 1) > perMinute)) -> false
      (!(perSecond > 0) or ((usedPerSecond + calculateSecondlyRunUsage(runUsage,date,time,0) + 1) > perSecond)) -> false
      true -> true
    end
  end
  
  defp validateUseOwnerShip(ownerId,userId,provisioned,useProvisioned) do
    sender = UserService.loadById(ownerId)
    senderCategory = MapUtil.get(sender,:category)
    senderOwnerId = NumberUtil.toInteger(MapUtil.get(sender,:ownerId))
    canUseNotProvisioned = (ownerId == 0 or (userId == ownerId and senderCategory == "admin_master"))
    #IO.inspect([ownerId,userId,provisioned,useProvisioned,senderCategory,senderOwnerId,canUseNotProvisioned])
    cond do
      (!provisioned and !canUseNotProvisioned) -> false
      (provisioned != useProvisioned) -> false
      (senderCategory == "external" and (userId != senderOwnerId)) -> false
      (useProvisioned && (userId != ownerId) && (userId != senderOwnerId)) -> false
      true -> true
    end
  end
  
  defp calculateMontlyRunUsage(array,date,total) do
    cond do
      (nil == array or length(array) == 0) -> total
      equalsMonthOfRunUsage(array,date) -> calculateMontlyRunUsage(tl(array),date,total + getTotalOfRunUsage(array)) 
      true -> calculateMontlyRunUsage(tl(array),date,total) 
    end
  end
  
  defp calculateDailyRunUsage(array,date,total) do
    cond do
      (nil == array or length(array) == 0) -> total
      equalsDayOfRunUsage(array,date) -> calculateDailyRunUsage(tl(array),date,total + getTotalOfRunUsage(array)) 
      true -> calculateDailyRunUsage(tl(array),date,total) 
    end
  end
  
  defp calculateHourlyRunUsage(array,date,time,total) do
    cond do
      (nil == array or length(array) == 0) -> total
      equalsHourOfRunUsage(array,date,time) 
        -> calculateHourlyRunUsage(tl(array),date,time,total + getTotalOfRunUsage(array)) 
      true -> calculateHourlyRunUsage(tl(array),date,time,total) 
    end
  end
  
  defp calculateMinutlyRunUsage(array,date,time,total) do
    cond do
      (nil == array or length(array) == 0) -> total
      equalsMinuteOfRunUsage(array,date,time) 
        -> calculateMinutlyRunUsage(tl(array),date,time,total + getTotalOfRunUsage(array)) 
      true -> calculateMinutlyRunUsage(tl(array),date,time,total) 
    end
  end
  
  defp calculateSecondlyRunUsage(array,date,time,total) do
    cond do
      (nil == array or length(array) == 0) -> total
      (equalsSecondOfRunUsage(array,date,time))
        -> calculateSecondlyRunUsage(tl(array),date,time,total + getTotalOfRunUsage(array)) 
      true -> calculateSecondlyRunUsage(tl(array),date,time,total) 
    end
  end
  
  defp equalsMonthOfRunUsage(array,date) do
    cond do
      (getYearOfRunUsage(array) == date.year and getMonthOfRunUsage(array) == date.month) -> true
      true -> false
    end
  end
  
  defp equalsDayOfRunUsage(array,date) do
    cond do
      (equalsMonthOfRunUsage(array,date) and getDayOfRunUsage(array) == date.day) -> true
      true -> false
    end
  end
  
  defp equalsHourOfRunUsage(array,date,time) do
    cond do
      (equalsDayOfRunUsage(array,date) and getHourOfRunUsage(array) == time.hour) -> true
      true -> false
    end
  end
  
  defp equalsMinuteOfRunUsage(array,date,time) do
    cond do
      (equalsHourOfRunUsage(array,date,time) and getMinuteOfRunUsage(array) == time.minute) -> true
      true -> false
    end
  end
  
  defp equalsSecondOfRunUsage(array,date,time) do
    cond do
      (equalsMinuteOfRunUsage(array,date,time) and getSecondOfRunUsage(array) == time.second) -> true
      true -> false
    end
  end
  
  defp getYearOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:year))
  end
  
  defp getMonthOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:month))
  end
  
  defp getDayOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:day))
  end
  
  defp getHourOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:hour))
  end
  
  defp getMinuteOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:minute))
  end
  
  defp getSecondOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:second))
  end
  
  defp getTotalOfRunUsage(array) do
    NumberUtil.toInteger(MapUtil.get(hd(array),:total))
  end
  
end
