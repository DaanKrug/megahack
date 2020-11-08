defmodule ExApp.SimpleMailValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getSubject(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:subject),defaultValue)
    SanitizerUtil.sanitize(value)
    cond do
      (String.length(value) > 200) -> value |> String.slice(0..200)
      true -> value
    end
  end
  
  def getContent(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:content),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getTosAddress(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:tosAddress),defaultValue)
    SanitizerUtil.sanitize(value)
  end
  
  def getStatus(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:status),defaultValue)
    value = SanitizerUtil.sanitizeAll(String.downcase(value),false,true,20,"a-z")
    cond do
      (value == "" or !Enum.member?(validStatus(),value)) -> validStatus() |> Enum.at(0)
      true -> value
    end
  end
  
  defp validStatus() do
    ["awaiting","reSend","startProcessing","processing","finished"]
  end
  
end
