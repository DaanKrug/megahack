defmodule ExApp.PageMenuItem do

   def new(id,name,content,position,active,pageMenuId,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,content,position,active,pageMenuId,ownerId)
       true -> newTotalRows(id,name,content,position,active,pageMenuId,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,content,position,active,pageMenuId,ownerId) do
     %{
       id: id,
       name: name,
       content: content,
       position: position,
       active: active,
       pageMenuId: pageMenuId,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,content,position,active,pageMenuId,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       content: content,
       position: position,
       active: active,
       pageMenuId: pageMenuId,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end