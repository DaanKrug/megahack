defmodule ExApp.ModuleValidator do

  alias ExApp.StringUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    value = SanitizerUtil.sanitizeAll(String.downcase(value),false,true,100,"A-z0-9Name")
    cond do
      (!Enum.member?(validModules(),value)) -> ""
      true -> value
    end
  end
  
  defp validModules() do
    ["file","image","slider","register","s3upload"]
  end
  
end