defmodule ExApp.S3ConfigValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getBucketName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:bucketName),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end
  
  def getBucketUrl(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:bucketUrl),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end
  
  def getRegion(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:region),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,30,"A-z0-9")
  end
  
  def getVersion(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:version),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,30,"A-z0-9")
  end
  
  def getKey(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:key),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,50,"A-z0-9")
  end
  
  def getSecret(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:secret),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,100,"A-z0-9")
  end
  
  
end