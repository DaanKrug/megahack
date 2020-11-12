defmodule ExApp.ConsumerunitHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.Consumerunit
  alias ExApp.GenericValidator
  alias ExApp.ConsumerunitValidator
  alias ExApp.ConsumerunitService 
  alias ExApp.SolicitationValidator
  alias ExApp.FaultreportService
  alias ExApp.RebindingrequestService
  alias ExApp.ConsumerunitService
  alias ExApp.BilletService
  
  
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
    noUnit = length(consumerUnits) == 0 or Enum.at(consumerUnits,0) |> MapUtil.get(:id) == 0
    cond do
      (noUnit and a3_cpf != "") -> MessagesUtil.systemMessage(100156)
      (noUnit) -> MessagesUtil.systemMessage(100157)
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
    noUnit = length(consumerUnits) == 0 or Enum.at(consumerUnits,0) |> MapUtil.get(:id) == 0
    cond do
      (noUnit and a3_cpf != "") -> MessagesUtil.systemMessage(100156)
      (noUnit) -> MessagesUtil.systemMessage(100157)
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
    id = MapUtil.get(consumerUnit,:id)
    clientId = MapUtil.get(consumerUnit,:a15_clientid)
    ownerId = MapUtil.get(consumerUnit,:ownerId)
    label = getConsumerUnitLabel(consumerUnit)
    cond do
      (nil == consumerUnit or !(id > 0)) -> MessagesUtil.systemMessage(100159)
      (FaultreportService.hasRecent(clientId,id)) 
        -> MessagesUtil.systemMessage(100158,[id,label,
                                              FaultreportService.loadLast(clientId,id) |> MapUtil.get(:id),
                                              getOtherProblemsInNeigborhood(consumerUnit)]) 
      (!(FaultreportService.create([clientId,id,ownerId]))) 
          -> MessagesUtil.systemMessage(100162,[id])
      true -> MessagesUtil.systemMessage(100158,[id,label,
                                                 FaultreportService.loadLast(clientId,id) |> MapUtil.get(:id),
                                                 getOtherProblemsInNeigborhood(consumerUnit)])
    end
  end
  
  defp registerReBindingByConsumerUnit(consumerUnit) do
    id = MapUtil.get(consumerUnit,:id)
    clientId = MapUtil.get(consumerUnit,:a15_clientid)
    ownerId = MapUtil.get(consumerUnit,:ownerId)
    label = getConsumerUnitLabel(consumerUnit)
    openBillets = loadOpenBillets(consumerUnit) |> StringUtil.trim()
    cond do
      (nil == consumerUnit or !(id > 0)) -> MessagesUtil.systemMessage(100159)
      (openBillets != "") -> MessagesUtil.systemMessage(100161,[id,label,openBillets])
      (RebindingrequestService.hasRecent(clientId,id)) 
        -> MessagesUtil.systemMessage(100160,[id,label,
                                              RebindingrequestService.loadLast(clientId,id) |> MapUtil.get(:id),
                                              ""])
      (!(RebindingrequestService.create([clientId,id,ownerId]))) 
          -> MessagesUtil.systemMessage(100163,[id])
      true -> MessagesUtil.systemMessage(100160,[id,label,
                                                 RebindingrequestService.loadLast(clientId,id) |> MapUtil.get(:id),
                                                 ""])
    end
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
  
  defp getOtherProblemsInNeigborhood(consumerUnit) do
    cep = MapUtil.get(consumerUnit,:a5_cep)
    clientId = MapUtil.get(consumerUnit,:a15_clientid)
    consumerUnitIds = ConsumerunitService.loadConsumerUnitIdsByCep(cep,clientId)
    cond do
      ((FaultreportService.hasRecentOthers(consumerUnitIds))) -> ""
      true -> "Já identificamos problemas na rede elétrica em sua vizinhança."
    end
  end
  
  defp loadOpenBillets(consumerUnit) do
    conditions = """
                 and a2_consumerunitid = #{MapUtil.get(consumerUnit,:id)}
                 and active = true
                 """
    cond do
      (nil == consumerUnit) -> []
      true -> BilletService.loadAll(-1,-1,conditions,AuthorizerUtil.getDeletedAt(nil,nil),nil)
                |> prepareOpenBillets("") 
    end
  end
  
  defp prepareOpenBillets(openBillets,preparedInfo) do
    cond do
      (nil == openBillets or length(openBillets) == 0) -> preparedInfo
      true -> prepareOpenBillets(tl(openBillets),
                                 "#{preparedInfo}#{getBilletLabel(hd(openBillets))}")
    end
  end
  
  defp getBilletLabel(billet) do
    cond do
      (!(MapUtil.get(billet,:id) > 0)) -> ""
      true -> """
			  | Fatura: #{MapUtil.get(billet,:id) |> StringUtil.leftZeros(20)},
			  Valor: #{MapUtil.get(billet,:a3_value) |> NumberUtil.toFloatFormat(2)},
			  Data do Vencimento: #{MapUtil.get(billet,:a4_billingdate) |> DateUtil.sqlDateToTime(false)},
			  """
    end
  end
  
end




