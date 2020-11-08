defmodule ExApp.BaseValidator do

  defmacro __using__(_opts) do
  
    quote do
    
      alias ExApp.StringUtil
  	  alias ExApp.StructUtil
  	  
  	  defp containsAll(list,value) do
	    StructUtil.listContainsAll(list,value |> StringUtil.trim() |> StringUtil.split(","))
	  end
  	  
  	end
  	
  end

end