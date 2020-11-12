defmodule ExApp.FaultreportHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Faultreport
  alias ExApp.GenericValidator
  alias ExApp.FaultreportValidator
  alias ExApp.FaultreportService 
  
  
  def objectClassName() do
    "Informe De Falta De Energia"
  end 
  
  def objectTableName() do
    "faultreport"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    a1_clientid = FaultreportValidator.getA1_clientid(mapParams)
    a2_consumerunitid = FaultreportValidator.getA2_consumerunitid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_clientid,a2_consumerunitid]
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty(params)) -> MessagesUtil.systemMessage(480,[objectClassName()])
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,faultreport,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == faultreport) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,faultreport) do
    cond do
      (!(id > 0) or nil == faultreport) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,faultreport) do
    cond do
      (!(id > 0) or nil == faultreport) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    a1_clientid = FaultreportValidator.getA1_clientid(mapParams)
    a2_consumerunitid = FaultreportValidator.getA2_consumerunitid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_clientid,a2_consumerunitid,ownerId]
	newObject = Faultreport.new(0,a1_clientid,a2_consumerunitid,ownerId)
    cond do
      (!(FaultreportService.create(params))) -> MessagesUtil.systemMessage(482,[objectClassName()])
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,faultreport,mapParams) do
    a1_clientid = FaultreportValidator.getA1_clientid(mapParams,MapUtil.get(faultreport,:a1_clientid))
    a2_consumerunitid = FaultreportValidator.getA2_consumerunitid(mapParams,MapUtil.get(faultreport,:a2_consumerunitid))
    params = [a1_clientid,a2_consumerunitid]
    cond do
      (!(FaultreportService.update(id,params))) -> MessagesUtil.systemMessage(483,[objectClassName()])
      true -> MessagesUtil.systemMessage(201)
    end
  end 
  
end