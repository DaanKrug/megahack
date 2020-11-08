defmodule ExApp.Image do

   def new(id,name,link,description,forPublic,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,name,link,description,forPublic,ownerId)
       true -> newTotalRows(id,name,link,description,forPublic,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,name,link,description,forPublic,ownerId) do
     %{
       id: id,
       name: name,
       link: link,
       description: description,
       forPublic: forPublic,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,name,link,description,forPublic,ownerId,totalRows) do
     %{
       id: id,
       name: name,
       link: link,
       description: description,
       forPublic: forPublic,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end