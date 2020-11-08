defmodule ExApp.SqlUtil do

  alias ExApp.StringUtil
  
  def getAllLikeSubstring(parameterName,parameterValue) do
    arrayValues =  StringUtil.splitInSubstrings(parameterValue)
    getAllLikeSubstringConditions(parameterName,arrayValues,[],0) |> Enum.join(" or ")
  end
  
  defp getAllLikeSubstringConditions(parameterName,values,array,counter) do
    cond do
      (counter >= length(values)) -> array
      (counter < 4) -> getAllLikeSubstringConditions(parameterName,values,array,counter + 1)
      true -> getAllLikeSubstringConditions(parameterName,values,
                                            array ++ ["#{parameterName} like '%#{Enum.at(values,counter)}%'"],
                                            counter + 1)
    end
  end
  
  
end