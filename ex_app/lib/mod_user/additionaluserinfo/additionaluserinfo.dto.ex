defmodule ExApp.Additionaluserinfo do

  def new(id,a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,a6_otherinfo,
          a7_userid,ownerId,totalRows \\ nil) do
    cond do
      (nil == totalRows) -> newNoTotalRows(id,a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,
                                           a6_otherinfo,a7_userid,ownerId)
      true -> newTotalRows(id,a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,
                           a6_otherinfo,a7_userid,ownerId,totalRows)
    end
  end
   
  defp newNoTotalRows(id,a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,
                      a6_otherinfo,a7_userid,ownerId) do
    %{
      id: id,
      a1_rg: a1_rg,
      a2_cpf: a2_cpf,
      a3_cns: a3_cns,
      a4_phone: a4_phone,
      a5_address: a5_address,
      a6_otherinfo: a6_otherinfo,
      a7_userid: a7_userid,
      ownerId: ownerId
    }
  end
   
  defp newTotalRows(id,a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,
                    a6_otherinfo,a7_userid,ownerId,totalRows) do
    %{
      id: id,
      a1_rg: a1_rg,
      a2_cpf: a2_cpf,
      a3_cns: a3_cns,
      a4_phone: a4_phone,
      a5_address: a5_address,
      a6_otherinfo: a6_otherinfo,
      a7_userid: a7_userid,
      ownerId: ownerId,
      totalRows: totalRows
    }
  end
   
end