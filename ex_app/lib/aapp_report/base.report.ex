defmodule ExApp.BaseReport do

  defmacro __using__(_opts) do
  
    quote do
    
  	  alias ExApp.StringUtil
  	  
	  defp getLabelByValue(allowedvaluesArray,value) do
	    cond do
	      (String.contains?(value,",")) -> getLabelByValueArray(allowedvaluesArray,StringUtil.split(value,","),"",0,",")
	      true -> getLabelByValueString(allowedvaluesArray,value,"",0,"")
	    end
	  end
	  
	  defp getLabelByValueArray(validValues,valuesArray,label,counter,joinChar) do
	    cond do
	      (counter >= length(valuesArray)) -> label
	      true -> getLabelByValueArray(validValues,valuesArray,
	                              getLabelByValueString(validValues,Enum.at(valuesArray,counter),label,0,joinChar),
	                              counter + 1,joinChar)
	    end
	  end
	  
	  defp getLabelByValueString(validValues,value,label,counter,joinChar) do
	    keyPar = cond do
	      (counter >= length(validValues)) -> nil
	      true -> Enum.at(validValues,counter) |> StringUtil.split("::") 
	    end
	    cond do
	      (nil == keyPar) -> label
	      (!(keyPar |> Enum.at(0) == value)) -> getLabelByValueString(validValues,value,label,counter + 1,joinChar)
	      (label != "" and joinChar != "") -> "#{label}#{joinChar}#{keyPar |> Enum.at(1)}"
	      true -> "#{label}#{keyPar |> Enum.at(1)}"
	    end
	  end
	  
    end
  end
end













