defmodule ExApp.Client do

  def new(id,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,a7_document,
          a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,a14_street,a15_number,
          a16_compl1type,a17_compl1desc,a18_compl2type,a19_compl2desc,ownerId,totalRows \\ nil) do
    cond do
      (nil == totalRows) -> newNoTotalRows(id,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,
                                           a6_doctype,a7_document,a8_gender,a9_email,a10_phone,
                                           a11_cep,a12_uf,a13_city,a14_street,a15_number,a16_compl1type,
                                           a17_compl1desc,a18_compl2type,a19_compl2desc,ownerId)
      true -> newTotalRows(id,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
                           a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,
                           a14_street,a15_number,a16_compl1type,a17_compl1desc,a18_compl2type,
                           a19_compl2desc,ownerId,totalRows)
    end
  end
   
  defp newNoTotalRows(id,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
                      a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,
                      a14_street,a15_number,a16_compl1type,a17_compl1desc,a18_compl2type,
                      a19_compl2desc,ownerId) do
    %{
      id: id,
      a1_name: a1_name,
      a2_type: a2_type,
      a3_cpf: a3_cpf,
      a4_cnpj: a4_cnpj,
      a5_birthdate: a5_birthdate,
      a6_doctype: a6_doctype,
      a7_document: a7_document,
      a8_gender: a8_gender,
      a9_email: a9_email,
      a10_phone: a10_phone,
      a11_cep: a11_cep,
      a12_uf: a12_uf,
      a13_city: a13_city,
      a14_street: a14_street,
      a15_number: a15_number,
      a16_compl1type: a16_compl1type,
      a17_compl1desc: a17_compl1desc,
      a18_compl2type: a18_compl2type,
      a19_compl2desc: a19_compl2desc,
      ownerId: ownerId
    }
  end
   
  defp newTotalRows(id,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
                    a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,
                    a14_street,a15_number,a16_compl1type,a17_compl1desc,a18_compl2type,
                    a19_compl2desc,ownerId,totalRows) do
    %{
      id: id,
      a1_name: a1_name,
      a2_type: a2_type,
      a3_cpf: a3_cpf,
      a4_cnpj: a4_cnpj,
      a5_birthdate: a5_birthdate,
      a6_doctype: a6_doctype,
      a7_document: a7_document,
      a8_gender: a8_gender,
      a9_email: a9_email,
      a10_phone: a10_phone,
      a11_cep: a11_cep,
      a12_uf: a12_uf,
      a13_city: a13_city,
      a14_street: a14_street,
      a15_number: a15_number,
      a16_compl1type: a16_compl1type,
      a17_compl1desc: a17_compl1desc,
      a18_compl2type: a18_compl2type,
      a19_compl2desc: a19_compl2desc,
      ownerId: ownerId,
      totalRows: totalRows
    }
  end
   
end