defmodule ExApp.AppConfigValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,50,"A-z0-9Name")
  end
  
  def getDescription(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:description),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end
  
  def getSite(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:site),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"url")
  end
  
  def getPricingPolicy(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:pricingPolicy),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getPrivacityPolicy(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:privacityPolicy),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getUsetermsPolicy(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:usetermsPolicy),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getUsecontractPolicy(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:usecontractPolicy),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getAuthorInfo(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:authorInfo),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
end
