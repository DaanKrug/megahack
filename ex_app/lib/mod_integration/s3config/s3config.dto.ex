defmodule ExApp.S3Config do

   def new(id,bucketName,bucketUrl,region,version,key,secret,active,ownerId,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,bucketName,bucketUrl,region,version,key,secret,active,ownerId)
       true -> newTotalRows(id,bucketName,bucketUrl,region,version,key,secret,active,ownerId,totalRows)
     end
   end
   
   defp newNoTotalRows(id,bucketName,bucketUrl,region,version,key,secret,active,ownerId) do
     %{
       id: id,
       bucketName: bucketName,
       bucketUrl: bucketUrl,
       region: region,
       version: version,
       key: key,
       secret: secret,
       active: active,
       ownerId: ownerId
     }
   end
   
   defp newTotalRows(id,bucketName,bucketUrl,region,version,key,secret,active,ownerId,totalRows) do
     %{
       id: id,
       bucketName: bucketName,
       bucketUrl: bucketUrl,
       region: region,
       version: version,
       key: key,
       secret: secret,
       active: active,
       ownerId: ownerId,
       totalRows: totalRows
     }
   end
   
end