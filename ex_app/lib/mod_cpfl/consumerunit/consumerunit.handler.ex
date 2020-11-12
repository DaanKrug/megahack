defmodule ExApp.ConsumerunitHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.Consumerunit
  alias ExApp.GenericValidator
  alias ExApp.ConsumerunitValidator
  alias ExApp.ConsumerunitService 
  alias ExApp.SolicitationValidator
  
  def objectClassName() do
    "Unidade Consumidora"
  end 
  
  def objectTableName() do
    "consumerunit"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["system_auditor","admin","admin_master","system_auditor"]
  end
  
  def validateToDelete(id,consumerunit) do
    cond do
      (!(id > 0) or nil == consumerunit) -> MessagesUtil.systemMessage(412)
      #(SolicitationService.clientIsIn(id)) -> MessagesUtil.systemMessage(100153)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,consumerunit) do
    cond do
      (!(id > 0) or nil == consumerunit) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
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
        -> Enum.at(consumerUnits,0) |> registerFaultByConsumerUnit()
      true -> consumerUnits
    end
  end
  
  def registerFaultByConsumerUnitId(id) do
    ConsumerunitService.loadById(id) |> registerFaultByConsumerUnit()
  end

  def registerReBinding(mapParams) do
    a3_cpf = SolicitationValidator.getA3_cpf(mapParams)
    a4_cnpj = SolicitationValidator.getA4_cnpj(mapParams)
    consumerUnits = loadConsumerUnits(a3_cpf,a4_cnpj)
    cond do
      (length(consumerUnits) == 0 and a3_cpf != "") -> MessagesUtil.systemMessage(100156)
      (length(consumerUnits) == 0) -> MessagesUtil.systemMessage(100157)
      (length(consumerUnits) == 1) 
        -> Enum.at(consumerUnits,0) |> registerReBindingByConsumerUnit()
      true -> consumerUnits
    end
  end
  
  def registerReBindingByConsumerUnitId(id) do
    ConsumerunitService.loadById(id) |> registerReBindingByConsumerUnit()
  end
  
  defp loadConsumerUnits(a3_cpf,a4_cnpj) do
    deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (a3_cpf == "" and a4_cnpj == "") -> []
      (a3_cpf != "") -> ConsumerunitService.loadAll(-1,-1," and a3_cpf = '#{a3_cpf}' ",deletedAt,nil)
      true -> ConsumerunitService.loadAll(-1,-1," and a4_cnpj = '#{a4_cnpj}' ",deletedAt,nil)
    end
  end
  
  defp registerFaultByConsumerUnit(consumerUnit) do
    cond do
      (nil == consumerUnit) -> MessagesUtil.systemMessage(100159)
      true -> MessagesUtil.systemMessage(100158,[getConsumerUnitNumber(consumerUnit),
                                                 getConsumerUnitLabel(consumerUnit),
                                                 "0000000XXXXXXXXX",
                                                 ""])
    end
  end
  
  defp registerReBindingByConsumerUnit(consumerUnit) do
    cond do
      (nil == consumerUnit) -> MessagesUtil.systemMessage(100161)
      true -> MessagesUtil.systemMessage(100160,[getConsumerUnitNumber(consumerUnit),
                                                 getConsumerUnitLabel(consumerUnit),
                                                 "0000000XXXXXXXXX",
                                                 ""])
    end
  end
  
  defp getConsumerUnitNumber(consumerUnit) do
    MapUtil.get(consumerUnit,:id)
  end
  
  defp getConsumerUnitLabel(consumerUnit) do
    streetNumber = MapUtil.get(consumerUnit,:a9_number) |> StringUtil.trim()
    streetNumber = cond do
      (streetNumber == "") -> "s/n"
      true -> streetNumber
    end
    """
    #{MapUtil.get(consumerUnit,:a8_street) |> StringUtil.trim()}, #{streetNumber},
    #{MapUtil.get(consumerUnit,:a7_city) |> StringUtil.trim()}/
    #{MapUtil.get(consumerUnit,:a6_uf) |> StringUtil.trim()} - CEP: 
    #{MapUtil.get(consumerUnit,:a5_cep) |> StringUtil.trim()}
    """
  end
  
  
end













