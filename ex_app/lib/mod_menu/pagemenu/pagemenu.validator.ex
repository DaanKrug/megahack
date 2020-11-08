defmodule ExApp.PageMenuValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"url")
  end
  
end