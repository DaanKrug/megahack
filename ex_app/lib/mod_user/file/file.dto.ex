defmodule ExApp.File do

   def new(id,name,link,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,link,ownerId)
       true -> newTotalRows(id,name,link,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,link,ownerId) do
     %{
       id: id,
       name: name,
       link: link,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,link,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       link: link,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end