defmodule ExApp.PageMenuItemFile do

   def new(id,name,position,fileId,fileLink,pageMenuItemId,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,position,fileId,fileLink,pageMenuItemId,ownerId)
       true -> newTotalRows(id,name,position,fileId,fileLink,pageMenuItemId,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,position,fileId,fileLink,pageMenuItemId,ownerId) do
     %{
       id: id,
       name: name,
       position: position,
       fileLink: fileLink,
       ownerId: ownerId,
       fileId: fileId,
       pageMenuItemId: pageMenuItemId
     }
   end
   
   defp newTotalRows(id,name,position,fileId,fileLink,pageMenuItemId,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       position: position,
       fileLink: fileLink,
       ownerId: ownerId,
       fileId: fileId,
       pageMenuItemId: pageMenuItemId,
       totalRows: totalRows
     }
   end
   
end