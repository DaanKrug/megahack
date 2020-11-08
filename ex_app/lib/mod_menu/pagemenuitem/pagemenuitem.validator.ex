defmodule ExApp.PageMenuItemValidator do

  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getContent(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:content),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getPageMenuId(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:pageMenuId),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,0,nil))
  end
  
end