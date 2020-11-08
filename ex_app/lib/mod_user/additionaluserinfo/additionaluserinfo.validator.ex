defmodule ExApp.AdditionaluserinfoValidator do
  
  use ExApp.BaseValidator
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getA1_rg(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a1_rg),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
  end 
  
  def getA2_cpf(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a2_cpf),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,14,"A-z0-9")
  end 
  
  def getA3_cns(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a3_cns),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,15,"0-9")
  end 
  
  def getA4_phone(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a4_phone),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"url")
  end 
  
  def getA5_address(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a5_address),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,500,"url")
  end 
  
  def getA6_otherinfo(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a6_otherinfo),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,500,"url")
  end 
  
  def getA7_userid(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:a7_userid),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,20,nil))
  end
  
end