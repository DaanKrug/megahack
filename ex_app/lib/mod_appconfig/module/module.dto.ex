defmodule ExApp.Module do

   def new(id,name,active,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,active,ownerId)
       true -> newTotalRows(id,name,active,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,active,ownerId) do
     %{
       id: id,
       name: name,
       active: active,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,active,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       active: active,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end