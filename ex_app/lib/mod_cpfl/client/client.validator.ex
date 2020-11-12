defmodule ExApp.ClientValidator do
  
  use ExApp.BaseValidator
  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getA1_name(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a1_name),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA2_type(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a2_type),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,2,"A-z0-9")
    validValues = ["PF","PJ"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA3_cpf(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a3_cpf),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
  end

  def getA4_cnpj(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a4_cnpj),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
  end

  def getA5_birthdate(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a5_birthdate),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,19,"DATE_SQL")
  end

  def getA6_doctype(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a6_doctype),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,30,"A-z0-9")
    validValues = ["rg","cnh","passport","reservistcart","workcart","nre"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA7_document(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a7_document),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,30,"A-z0-9")
  end

  def getA8_gender(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a8_gender),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,20,"A-z0-9")
    validValues = ["M","F","O"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA9_email(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a9_email),defaultValue) |> String.downcase()
    SanitizerUtil.sanitizeAll(value,false,true,100,"A-z0-9")
  end

  def getA10_phone(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a10_phone),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA11_cep(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a11_cep),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,10,"A-z0-9")
  end

  def getA12_uf(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a12_uf),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,2,"A-z0-9")
  end

  def getA13_city(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a13_city),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA14_street(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a14_street),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA15_number(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a15_number),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,10,"A-z0-9")
  end

  def getA16_compl1type(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a16_compl1type),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["adminstracao","altos","apartamento","armazem","baixos","bancajornal",
                   "barraca","barracao","bilheteria","loja","lote","sala","salao"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA17_compl1desc(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a17_compl1desc),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
  end

  def getA18_compl2type(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a18_compl2type),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["acesso","andar","anexo","clube","colegio","colonia","cruzamento"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end

  def getA19_compl2desc(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:a19_compl2desc),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    validValues = ["acesso","andar","anexo","clube","colegio","colonia"]
    member = Enum.member?(validValues,value)
    cond do
      (!member and nil == defaultValue) -> Enum.at(validValues,0)
      (!member) -> defaultValue
      true -> value
    end
  end 
  
end