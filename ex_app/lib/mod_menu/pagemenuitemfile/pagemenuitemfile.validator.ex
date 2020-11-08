defmodule ExApp.PageMenuItemFileValidator do

  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getPageMenuItemId(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:pageMenuItemId),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,0,nil))
  end
  
end