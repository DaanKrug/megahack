defmodule ExApp.BilletHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Billet
  alias ExApp.GenericValidator
  alias ExApp.BilletValidator
  alias ExApp.BilletService 
  alias ExApp.ConsumerunitService
  alias ExApp.ClientService
  
  
  def objectClassName() do
    "Fatura Energia"
  end 
  
  def objectTableName() do
    "billet"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    a1_clientid = BilletValidator.getA1_clientid(mapParams)
    a2_consumerunitid = BilletValidator.getA2_consumerunitid(mapParams)
    a4_billingdate = BilletValidator.getA4_billingdate(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([a4_billingdate])) 
        -> MessagesUtil.systemMessage(480,[objectClassName()])
      (SanitizerUtil.hasLessThan([a1_clientid,a2_consumerunitid],1)) 
        -> MessagesUtil.systemMessage(480,[objectClassName()])
      (nil == ConsumerunitService.loadById(a2_consumerunitid)) 
        -> MessagesUtil.systemMessage(100164)
      (nil == ClientService.loadById(a1_clientid)) 
        -> MessagesUtil.systemMessage(100165)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,billet,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == billet) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,billet) do
    cond do
      (!(id > 0) or nil == billet) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,billet) do
    cond do
      (!(id > 0) or nil == billet) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    a1_clientid = BilletValidator.getA1_clientid(mapParams)
    a2_consumerunitid = BilletValidator.getA2_consumerunitid(mapParams)
    a3_value = BilletValidator.getA3_value(mapParams)
    a4_billingdate = BilletValidator.getA4_billingdate(mapParams)
    active = GenericValidator.getBool(mapParams,"active",true)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId]
	newObject = Billet.new(0,a1_clientid,a2_consumerunitid,a3_value,a4_billingdate,active,ownerId)
    cond do
      (!(BilletService.create(params))) 
        -> MessagesUtil.systemMessage(482,[objectClassName()])
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,billet,mapParams) do
    a3_value = BilletValidator.getA3_value(mapParams,MapUtil.get(billet,:a3_value))
    a4_billingdate = BilletValidator.getA4_billingdate(mapParams,MapUtil.get(billet,:a4_billingdate))
    active = GenericValidator.getBool(mapParams,"active",MapUtil.get(billet,:active))
    params = [a3_value,a4_billingdate,active]
    cond do
      (!(BilletService.update(id,params))) 
        -> MessagesUtil.systemMessage(483,[objectClassName()])
      true -> MessagesUtil.systemMessage(201)
    end
  end 
  
end