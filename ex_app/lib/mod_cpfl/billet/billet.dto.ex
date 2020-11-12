defmodule ExApp.Billet do

  def new(id,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId,totalRows \\ nil) do
    cond do
      (nil == totalRows) -> newNoTotalRows(id,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId)
      true -> newTotalRows(id,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId,totalRows)
    end
  end
   
  defp newNoTotalRows(id,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId) do
    %{
      id: id,
      a1_clientid: a1_clientid,
      a2_consumerunitid: a2_consumerunitid,
      a3_value: a3_value,
      a4_billingdate: a4_billingdate,
      active: active,
      ownerId: ownerId
    }
  end
   
  defp newTotalRows(id,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId,totalRows) do
    %{
      id: id,
      a1_clientid: a1_clientid,
      a2_consumerunitid: a2_consumerunitid,
      a3_value: a3_value,
      a4_billingdate: a4_billingdate,
      active: active,
      ownerId: ownerId,
      totalRows: totalRows
    }
  end
   
end