defmodule ExApp.AdditionaluserinfoHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.Additionaluserinfo
  alias ExApp.GenericValidator
  alias ExApp.AdditionaluserinfoValidator
  alias ExApp.AdditionaluserinfoService
  alias ExApp.UserService
  alias ExApp.UserValidator
  alias ExApp.UserServiceApp
  
  
  def objectClassName() do
    "Informação Complementar"
  end 
  
  def objectTableName() do
    "additionaluserinfo"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    email = UserValidator.getEmail(mapParams)
    a7_userid = AdditionaluserinfoValidator.getA7_userid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([ownerId],1)) 
        -> MessagesUtil.systemMessage(480,[objectClassName()])
      (!(a7_userid > 0) and email == "") 
        -> MessagesUtil.systemMessage(480,[objectClassName()])
      (a7_userid > 0 and nil == UserService.loadById(a7_userid)) 
        -> MessagesUtil.systemMessage(100065)
      (email != "" and 0 == UserServiceApp.loadIdByEmail(email)) 
        -> MessagesUtil.systemMessage(100065)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,additionaluserinfo,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == additionaluserinfo) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,additionaluserinfo) do
    cond do
      (!(id > 0) or nil == additionaluserinfo) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,additionaluserinfo) do
    cond do
      (!(id > 0) or nil == additionaluserinfo) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    a1_rg = AdditionaluserinfoValidator.getA1_rg(mapParams)
    a2_cpf = AdditionaluserinfoValidator.getA2_cpf(mapParams)
    a3_cns = AdditionaluserinfoValidator.getA3_cns(mapParams)
    a4_phone = AdditionaluserinfoValidator.getA4_phone(mapParams)
    a5_address = AdditionaluserinfoValidator.getA5_address(mapParams)
    a6_otherinfo = AdditionaluserinfoValidator.getA6_otherinfo(mapParams)
    a7_userid = AdditionaluserinfoValidator.getA7_userid(mapParams)
    a7_userid = cond do
      (a7_userid > 0) -> a7_userid
      true -> UserValidator.getEmail(mapParams) |> UserServiceApp.loadIdByEmail()
    end
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,a6_otherinfo,a7_userid,ownerId]
	newObject = Additionaluserinfo.new(0,a1_rg,a2_cpf,a3_cns,a4_phone,
	                                   a5_address,a6_otherinfo,a7_userid,ownerId)
    cond do
      (!(AdditionaluserinfoService.create(params))) 
        -> MessagesUtil.systemMessage(100161)
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,_additionaluserinfo,mapParams) do
    a1_rg = AdditionaluserinfoValidator.getA1_rg(mapParams)
    a2_cpf = AdditionaluserinfoValidator.getA2_cpf(mapParams)
    a3_cns = AdditionaluserinfoValidator.getA3_cns(mapParams)
    a4_phone = AdditionaluserinfoValidator.getA4_phone(mapParams)
    a5_address = AdditionaluserinfoValidator.getA5_address(mapParams)
    a6_otherinfo = AdditionaluserinfoValidator.getA6_otherinfo(mapParams)
    params = [a1_rg,a2_cpf,a3_cns,a4_phone,a5_address,a6_otherinfo]
    cond do
      (!(AdditionaluserinfoService.update(id,params))) 
        -> MessagesUtil.systemMessage(100162)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end