defmodule ExApp.MailerConfigValidator do

  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getProvider(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:provider),defaultValue)
    value = SanitizerUtil.sanitizeAll(String.downcase(value),false,true,30,"A-z0-9")
    cond do
      (!Enum.member?(validProviders(),value)) -> ""
      true -> value
    end
  end
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,30,"A-z0-9")
  end
  
  def getUserName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:username),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,100,"email")
  end
  
  def getPassword(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:password),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"password")
  end
  
  def getPerMonth(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:perMonth),defaultValue,true)
    value = NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,10,nil))
    NumberUtil.coalesceInterval(value,0,NumberUtil.maxInteger())
  end
  
  def getPerDay(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:perDay),defaultValue,true)
    value = NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,10,nil))
    NumberUtil.coalesceInterval(value,0,NumberUtil.maxInteger())
  end
  
  def getPerHour(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:perHour),defaultValue,true)
    value = NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,10,nil))
    NumberUtil.coalesceInterval(value,1,NumberUtil.maxInteger())
  end
  
  def getPerMinute(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:perMinute),defaultValue,true)
    value = NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,10,nil))
    NumberUtil.coalesceInterval(value,1,NumberUtil.maxInteger())
  end
  
  def getPerSecond(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:perSecond),defaultValue,true)
    value = NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,10,nil))
    NumberUtil.coalesceInterval(value,1,NumberUtil.maxInteger())
  end
  
  def getReplayTo(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:replayTo),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,100,"email")
  end
  
  defp validProviders() do
    ["skallerten","gmail","mailgun","mailjet","sendinblue","sparkpost",
     "sendgrid","smtp2go","elasticemail","iagente","socketlab","postmark"]
  end
  
end
				
				