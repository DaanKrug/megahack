defmodule ExApp.ConsumerunitHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Consumerunit
  alias ExApp.GenericValidator
  alias ExApp.ConsumerunitValidator
  alias ExApp.ConsumerunitService 
  alias ExApp.SolicitationValidator
  
 
  defp loadConsumerUnits(a3_cpf,a4_cnpj) do
    deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (a3_cpf == "" and a4_cnpj == "") -> []
      (a3_cpf != "") -> ConsumerunitService.loadAll(-1,-1," and a3_cpf = '#{a3_cpf}' ",deletedAt,nil)
      true -> ConsumerunitService.loadAll(-1,-1," and a4_cnpj = '#{a4_cnpj}' ",deletedAt,nil)
    end
  end
  
  def registerFault(mapParams) do
    a3_cpf = SolicitationValidator.getA3_cpf(mapParams)
    a4_cnpj = SolicitationValidator.getA4_cnpj(mapParams)
    consumerUnits = loadConsumerUnits(a3_cpf,a4_cnpj)
    cond do
      (length(consumerUnits) == 0 and a3_cpf != "") -> MessagesUtil.systemMessage(100156)
      (length(consumerUnits) == 0) -> MessagesUtil.systemMessage(100157)
      (length(consumerUnits) == 1) 
        -> MessagesUtil.systemMessage(100158,[Enum.at(consumerUnits,0) |> MapUtil.get(:id),"0000000123456789"])
      true -> consumerUnits
    end
  end
  
  def registerFaultByConsumerUnitId(id) do
    consumerUnit = ConsumerunitService.loadById(id)
    cond do
      (nil == consumerUnit) -> MessagesUtil.systemMessage(100159)
      true -> MessagesUtil.systemMessage(100158,[id,"0000000XXXXXXXXX"])
    end
  end
  
  
end













