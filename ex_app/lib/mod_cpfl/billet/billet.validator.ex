defmodule ExApp.BilletValidator do
  
  use ExApp.BaseValidator
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getA1_clientid(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:a1_clientid),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,20,nil))
  end

  def getA2_consumerunitid(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:a2_consumerunitid),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,20,nil))
  end

  def getA3_value(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:a3_value),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,true,true,12,"0-9")
    NumberUtil.toFloat(value)
  end

  def getA4_billingdate(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a4_billingdate),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,19,"DATE_SQL")
  end 
  
end