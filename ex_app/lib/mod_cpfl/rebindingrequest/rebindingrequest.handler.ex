defmodule ExApp.RebindingrequestHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Rebindingrequest
  alias ExApp.GenericValidator
  alias ExApp.RebindingrequestValidator
  alias ExApp.RebindingrequestService 
  
  
  def objectClassName() do
    "Solicita&ccedil;&atilde;o De Re-ligamento"
  end 
  
  def objectTableName() do
    "rebindingrequest"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    a1_clientid = RebindingrequestValidator.getA1_clientid(mapParams)
    a2_consumerunitid = RebindingrequestValidator.getA2_consumerunitid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_clientid,a2_consumerunitid]
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty(params)) -> MessagesUtil.systemMessage(480,[objectClassName()])
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,rebindingrequest,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == rebindingrequest) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,rebindingrequest) do
    cond do
      (!(id > 0) or nil == rebindingrequest) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,rebindingrequest) do
    cond do
      (!(id > 0) or nil == rebindingrequest) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    a1_clientid = RebindingrequestValidator.getA1_clientid(mapParams)
    a2_consumerunitid = RebindingrequestValidator.getA2_consumerunitid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_clientid,a2_consumerunitid,ownerId]
	newObject = Rebindingrequest.new(0,a1_clientid,a2_consumerunitid,ownerId)
    cond do
      (!(RebindingrequestService.create(params))) -> MessagesUtil.systemMessage(482,[objectClassName()])
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,rebindingrequest,mapParams) do
    a1_clientid = RebindingrequestValidator.getA1_clientid(mapParams,MapUtil.get(rebindingrequest,:a1_clientid))
    a2_consumerunitid = RebindingrequestValidator.getA2_consumerunitid(mapParams,MapUtil.get(rebindingrequest,:a2_consumerunitid))
    params = [a1_clientid,a2_consumerunitid]
    cond do
      (!(RebindingrequestService.update(id,params))) -> MessagesUtil.systemMessage(483,[objectClassName()])
      true -> MessagesUtil.systemMessage(201)
    end
  end 
  
end