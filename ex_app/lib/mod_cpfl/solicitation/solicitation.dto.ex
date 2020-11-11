defmodule ExApp.Solicitation do

  def new(id,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,a6_uf,a7_city,a8_street,
          a9_number,a10_compl1type,a11_compl1desc,a12_compl2type,a13_compl2desc,
          a14_reference,a15_clientid,active,ownerId,totalRows \\ nil) do
    cond do
      (nil == totalRows) -> newNoTotalRows(id,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,
                                           a5_cep,a6_uf,a7_city,a8_street,a9_number,a10_compl1type,
                                           a11_compl1desc,a12_compl2type,a13_compl2desc,a14_reference,
                                           a15_clientid,active,ownerId)
      true -> newTotalRows(id,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,a6_uf,
                           a7_city,a8_street,a9_number,a10_compl1type,a11_compl1desc,
                           a12_compl2type,a13_compl2desc,a14_reference,a15_clientid,
                           active,ownerId,totalRows)
    end
  end
   
  defp newNoTotalRows(id,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,a6_uf,
                      a7_city,a8_street,a9_number,a10_compl1type,a11_compl1desc,a12_compl2type,
                      a13_compl2desc,a14_reference,a15_clientid,active,ownerId) do
    %{
      id: id,
      a1_name: a1_name,
      a3_cpf: a3_cpf,
      a4_cnpj: a4_cnpj,
      a2_caracteristic: a2_caracteristic,
      a5_cep: a5_cep,
      a6_uf: a6_uf,
      a7_city: a7_city,
      a8_street: a8_street,
      a9_number: a9_number,
      a10_compl1type: a10_compl1type,
      a11_compl1desc: a11_compl1desc,
      a12_compl2type: a12_compl2type,
      a13_compl2desc: a13_compl2desc,
      a14_reference: a14_reference,
      a15_clientid: a15_clientid,
      active: active,
      ownerId: ownerId
    }
  end
   
  defp newTotalRows(id,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,a6_uf,a7_city,
                    a8_street,a9_number,a10_compl1type,a11_compl1desc,a12_compl2type,
                    a13_compl2desc,a14_reference,a15_clientid,active,ownerId,totalRows) do
    %{
      id: id,
      a1_name: a1_name,
      a3_cpf: a3_cpf,
      a4_cnpj: a4_cnpj,
      a2_caracteristic: a2_caracteristic,
      a5_cep: a5_cep,
      a6_uf: a6_uf,
      a7_city: a7_city,
      a8_street: a8_street,
      a9_number: a9_number,
      a10_compl1type: a10_compl1type,
      a11_compl1desc: a11_compl1desc,
      a12_compl2type: a12_compl2type,
      a13_compl2desc: a13_compl2desc,
      a14_reference: a14_reference,
      a15_clientid: a15_clientid,
      active: active,
      ownerId: ownerId,
      totalRows: totalRows
    }
  end
   
end