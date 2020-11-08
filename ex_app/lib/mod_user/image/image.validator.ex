defmodule ExApp.ImageValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  alias ExApp.ImageUtil
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    SanitizerUtil.sanitizeAll(StringUtil.capitalize(value),false,true,100,"A-z0-9Name")
  end
  
  def getLink(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:link),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,0,"url")
    validImage = ImageUtil.validateUrl(value)
    cond do
      (validImage) -> value
      (nil == defaultValue) -> ""
      true -> defaultValue
    end
  end
  
  def getDescription(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:description),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end
  
end