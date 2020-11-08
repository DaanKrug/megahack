defmodule ExApp.SimpleMailHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.StructUtil
  alias ExApp.StringUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.SimpleMailService
  alias ExApp.GenericValidator
  alias ExApp.SimpleMailValidator
  alias ExApp.SimpleMail
  
  def objectClassName() do
    "E-mail"
  end 
  
  def objectTableName() do
    "simplemail"
  end
  
  def accessCategories() do
    ["admin_master","admin","external"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    subject = SimpleMailValidator.getSubject(mapParams)
    content = SimpleMailValidator.getContent(mapParams)
	tosAddress = SimpleMailValidator.getTosAddress(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0) or SanitizerUtil.hasEmpty([subject,content,tosAddress])) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,simpleMail,mapParams) do
	subject = SimpleMailValidator.getSubject(mapParams,MapUtil.get(simpleMail,:subject))
    content = SimpleMailValidator.getContent(mapParams,MapUtil.get(simpleMail,:content))
	tos = SimpleMailValidator.getTosAddress(mapParams,MapUtil.get(simpleMail,:tos))
	status = SimpleMailValidator.getStatus(mapParams,MapUtil.get(simpleMail,:status))
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == simpleMail) -> MessagesUtil.systemMessage(412)
      (StructUtil.listContains(["startProcessing","processing"],MapUtil.get(simpleMail,:status))) -> MessagesUtil.systemMessage(100014)
      (MapUtil.get(simpleMail,:successTotal) > 0 
        and changedOrNotResend(simpleMail,subject,content,tos,status)) -> MessagesUtil.systemMessage(100018)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,simpleMail) do
    cond do
      (!(id > 0) or nil == simpleMail) -> MessagesUtil.systemMessage(412)
      (StructUtil.listContains(["startProcessing","processing"],MapUtil.get(simpleMail,:status))) -> MessagesUtil.systemMessage(100015)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,simpleMail) do
    cond do
      (!(id > 0) or nil == simpleMail) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    subject = SimpleMailValidator.getSubject(mapParams)
    content = SimpleMailValidator.getContent(mapParams)
	tosAddress = SimpleMailValidator.getTosAddress(mapParams)
	randomKey = GenericValidator.getRandomKey(mapParams,SanitizerUtil.generateRandom(50))
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [subject,content,tosAddress,"awaiting",randomKey,ownerId]
	newSimpleMail = SimpleMail.new(0,subject,content,tosAddress,"","","awaiting",
	                               length(StringUtil.split(tosAddress,",")),0,0,ownerId,nil)
    cond do
      (!(SimpleMailService.create(params))) -> MessagesUtil.systemMessage(100016)
      true -> MessagesUtil.systemMessage(200,[newSimpleMail])
    end
  end
  
  def update(id,simpleMail,mapParams) do
    subject = SimpleMailValidator.getSubject(mapParams,MapUtil.get(simpleMail,:subject))
    content = SimpleMailValidator.getContent(mapParams,MapUtil.get(simpleMail,:content))
	tosAddress = SimpleMailValidator.getTosAddress(mapParams,MapUtil.get(simpleMail,:tosAddress))
	status = SimpleMailValidator.getStatus(mapParams,MapUtil.get(simpleMail,:status))
	params = [subject,content,tosAddress,status]
    cond do
      (!(SimpleMailService.update(id,params))) -> MessagesUtil.systemMessage(100017)
      true -> MessagesUtil.systemMessage(201)
    end
  end
 
  defp changedOrNotResend(simpleMail,subject,content,tosAddress,status) do
    cond do
      (subject != MapUtil.get(simpleMail,:subject)) -> true
      (content != MapUtil.get(simpleMail,:content)) -> true
      (tosAddress != MapUtil.get(simpleMail,:tosAddress)) -> true
      true -> status != "reSend"
    end
  end
  
end
