defmodule ExApp.Rebindingrequest do

  def new(id,a1_clientid,a2_consumerunitid,ownerId,totalRows \\ nil) do
    cond do
      (nil == totalRows) -> newNoTotalRows(id,a1_clientid,a2_consumerunitid,ownerId)
      true -> newTotalRows(id,a1_clientid,a2_consumerunitid,ownerId,totalRows)
    end
  end
   
  defp newNoTotalRows(id,a1_clientid,a2_consumerunitid,ownerId) do
    %{
      id: id,
      a1_clientid: a1_clientid,
      a2_consumerunitid: a2_consumerunitid,
      ownerId: ownerId
    }
  end
   
  defp newTotalRows(id,a1_clientid,a2_consumerunitid,ownerId,totalRows) do
    %{
      id: id,
      a1_clientid: a1_clientid,
      a2_consumerunitid: a2_consumerunitid,
      ownerId: ownerId,
      totalRows: totalRows
    }
  end
   
end