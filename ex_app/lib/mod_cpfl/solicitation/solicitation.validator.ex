defmodule ExApp.SolicitationValidator do
  
  use ExApp.BaseValidator
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getA1_name(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a1_name),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA3_cpf(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a3_cpf),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
  end

  def getA4_cnpj(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a4_cnpj),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
  end

  def getA2_caracteristic(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a2_caracteristic),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,2,"A-z0-9")
    validValues = ["l1","l2","l3","l4"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA5_cep(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a5_cep),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,10,"A-z0-9")
  end

  def getA6_uf(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a6_uf),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,2,"A-z0-9")
  end

  def getA7_city(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a7_city),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA8_street(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a8_street),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA9_number(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a9_number),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,10,"A-z0-9")
  end

  def getA10_compl1type(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a10_compl1type),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["adminstracao","altos","apartamento","armazem","baixos",
                   "bancajornal","barraca","barracao","bilheteria","loja","lote","sala","salao"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA11_compl1desc(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a11_compl1desc),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA12_compl2type(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a12_compl2type),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["acesso","andar","anexo","clube","colegio","colonia","cruzamento"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA13_compl2desc(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a13_compl2desc),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["acesso","andar","anexo","clube","colegio","colonia"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA14_reference(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a14_reference),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA15_clientid(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:a15_clientid),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,20,nil))
  end 
  
end