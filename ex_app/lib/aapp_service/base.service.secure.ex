defmodule ExApp.BaseServiceSecure do

  defmacro __using__(_opts) do
  
    quote do
     
      def loadForEdit(id) do
        loadById(id)
      end
      
    end
   
  end
  
end