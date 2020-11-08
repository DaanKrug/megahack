defmodule ExApp.TimeSync do

   def new(id,language,systemdiff,totalRows \\ nil) do
     cond do
       (nil == totalRows) -> newNoTotalRows(id,language,systemdiff)
       true -> newTotalRows(id,language,systemdiff,totalRows)
     end
   end
   
   defp newNoTotalRows(id,language,systemdiff) do
     %{
       id: id,
       language: language,
       systemdiff: systemdiff
     }
   end
   
   defp newTotalRows(id,language,systemdiff,totalRows) do
     %{
       id: id,
       language: language,
       systemdiff: systemdiff,
       totalRows: totalRows
     }
   end
   
end