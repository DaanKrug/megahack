defmodule ExApp.SimpleMail do

   def new(id,subject,content,tosAddress,successAddress,failAddress,status,
           tosTotal,successTotal,failTotal,ownerId,updated_at,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,subject,content,tosAddress,successAddress,failAddress,status,
                                            tosTotal,successTotal,failTotal,ownerId,updated_at)
       true -> newTotalRows(id,subject,content,tosAddress,successAddress,failAddress,status,
                            tosTotal,successTotal,failTotal,ownerId,updated_at,totalRows)
     end
   end
   
   defp newNoTotalRows(id,subject,content,tosAddress,successAddress,failAddress,status,
                       tosTotal,successTotal,failTotal,ownerId,updated_at) do
     %{
       id: id,
       subject: subject,
       content: content,
       tosAddress: tosAddress,
       tosTotal: tosTotal,
       ownerId: ownerId,
       successAddress: successAddress, 
       failAddress: failAddress,
       status: status,
       successTotal: successTotal,
       failTotal: failTotal,
       updated_at: updated_at
     }
   end
   
   defp newTotalRows(id,subject,content,tosAddress,successAddress,failAddress,status,
                     tosTotal,successTotal,failTotal,ownerId,updated_at,totalRows) do
     %{
       id: id,
       subject: subject,
       content: content,
       tosAddress: tosAddress,
       tosTotal: tosTotal,
       ownerId: ownerId,
       successAddress: successAddress, 
       failAddress: failAddress,
       status: status,
       successTotal: successTotal,
       failTotal: failTotal,
       updated_at: updated_at,
       totalRows: totalRows
     }
   end
   
end