defmodule ExApp.SNTPUtil do

  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  
  def getSNTP() do
    list = SNTP.time() |> Tuple.to_list()
    cond do
      (list |> Enum.at(0) == :ok) -> list 
                                       |> Enum.at(1) 
                                       |> MapUtil.get(:originate_timestamp)
                                       |> StringUtil.split(".")
                                       |> Enum.at(0)
                                       |> NumberUtil.toInteger()
      true -> getSNTP()
    end
  end

end