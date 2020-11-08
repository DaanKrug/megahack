defmodule ExApp.PageMenu do

   def new(id,name,position,active,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,position,active,ownerId)
       true -> newTotalRows(id,name,position,active,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,position,active,ownerId) do
     %{
       id: id,
       name: name,
       position: position,
       active: active,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,position,active,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       position: position,
       active: active,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end