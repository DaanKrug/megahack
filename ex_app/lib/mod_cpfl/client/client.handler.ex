defmodule ExApp.ClientHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Client
  alias ExApp.GenericValidator
  alias ExApp.ClientValidator
  alias ExApp.ClientService 
  alias ExApp.SolicitationService
  alias ExApp.UserService
  
  def objectClassName() do
    "Cliente"
  end 
  
  def objectTableName() do
    "client"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["system_auditor","admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    id = GenericValidator.getId(mapParams)
    a1_name = ClientValidator.getA1_name(mapParams)
    a2_type = ClientValidator.getA2_type(mapParams)
    a3_cpf = ClientValidator.getA3_cpf(mapParams)
    a4_cnpj = ClientValidator.getA4_cnpj(mapParams)
    a5_birthdate = ClientValidator.getA5_birthdate(mapParams)
    a6_doctype = ClientValidator.getA6_doctype(mapParams)
    a7_document = ClientValidator.getA7_document(mapParams)
    a8_gender = ClientValidator.getA8_gender(mapParams)
    a10_phone = ClientValidator.getA10_phone(mapParams)
    a11_cep = ClientValidator.getA11_cep(mapParams)
    a12_uf = ClientValidator.getA12_uf(mapParams)
    a13_city = ClientValidator.getA13_city(mapParams)
    a14_street = ClientValidator.getA14_street(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_name,a2_type,a5_birthdate,a6_doctype,a7_document,
	          a8_gender,a10_phone,a11_cep,a12_uf,a13_city,a14_street]
	IO.inspect(params)
    cond do
      (!(ownerId > 0) and !(id == -1 and ownerId == 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty(params)) -> MessagesUtil.systemMessage(480,[objectClassName()])
      (a2_type == "PF" and a3_cpf == "") -> MessagesUtil.systemMessage(480,[objectClassName()])
      (a2_type == "PJ" and a4_cnpj == "") -> MessagesUtil.systemMessage(480,[objectClassName()])
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,client,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == client) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,client) do
    cond do
      (!(id > 0) or nil == client) -> MessagesUtil.systemMessage(412)
      (SolicitationService.clientIsIn(id)) -> MessagesUtil.systemMessage(100153)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,client) do
    cond do
      (!(id > 0) or nil == client) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,escapedAuth) do
    a1_name = ClientValidator.getA1_name(mapParams)
    a2_type = ClientValidator.getA2_type(mapParams)
    a3_cpf = ClientValidator.getA3_cpf(mapParams)
    a4_cnpj = ClientValidator.getA4_cnpj(mapParams)
    a5_birthdate = ClientValidator.getA5_birthdate(mapParams)
    a6_doctype = ClientValidator.getA6_doctype(mapParams)
    a7_document = ClientValidator.getA7_document(mapParams)
    a8_gender = ClientValidator.getA8_gender(mapParams)
    a9_email = ClientValidator.getA9_email(mapParams)
    a10_phone = ClientValidator.getA10_phone(mapParams)
    a11_cep = ClientValidator.getA11_cep(mapParams)
    a12_uf = ClientValidator.getA12_uf(mapParams)
    a13_city = ClientValidator.getA13_city(mapParams)
    a14_street = ClientValidator.getA14_street(mapParams)
    a15_number = ClientValidator.getA15_number(mapParams)
    a16_compl1type = ClientValidator.getA16_compl1type(mapParams)
    a17_compl1desc = ClientValidator.getA17_compl1desc(mapParams)
    a18_compl2type = ClientValidator.getA18_compl2type(mapParams)
    a19_compl2desc = ClientValidator.getA19_compl2desc(mapParams)
	ownerId = cond do
      (escapedAuth) -> UserService.loadFirstMasterAdminId()
      true -> GenericValidator.getOwnerId(mapParams)
    end
	params = [a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
	          a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,
	          a14_street,a15_number,a16_compl1type,a17_compl1desc,
	          a18_compl2type,a19_compl2desc,ownerId]
	newObject = Client.new(0,a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
	                       a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,a13_city,
	                       a14_street,a15_number,a16_compl1type,a17_compl1desc,a18_compl2type,
	                       a19_compl2desc,ownerId)
    cond do
      (!(ClientService.create(params))) 
        -> MessagesUtil.systemMessage(100148)
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,client,mapParams) do
    a1_name = ClientValidator.getA1_name(mapParams,MapUtil.get(client,:a1_name))
    a2_type = ClientValidator.getA2_type(mapParams,MapUtil.get(client,:a2_type))
    a3_cpf = cond do
      (a2_type == "PF") -> ClientValidator.getA3_cpf(mapParams,MapUtil.get(client,:a3_cpf))
      true -> ""
    end
    a4_cnpj = cond do
      (a2_type == "PJ") -> ClientValidator.getA4_cnpj(mapParams,MapUtil.get(client,:a4_cnpj))
      true -> ""
    end
    a5_birthdate = ClientValidator.getA5_birthdate(mapParams,MapUtil.get(client,:a5_birthdate))
    a6_doctype = ClientValidator.getA6_doctype(mapParams,MapUtil.get(client,:a6_doctype))
    a7_document = ClientValidator.getA7_document(mapParams,MapUtil.get(client,:a7_document))
    a8_gender = ClientValidator.getA8_gender(mapParams,MapUtil.get(client,:a8_gender))
    a9_email = ClientValidator.getA9_email(mapParams)
    a10_phone = ClientValidator.getA10_phone(mapParams,MapUtil.get(client,:a10_phone))
    a11_cep = ClientValidator.getA11_cep(mapParams,MapUtil.get(client,:a11_cep))
    a12_uf = ClientValidator.getA12_uf(mapParams,MapUtil.get(client,:a12_uf))
    a13_city = ClientValidator.getA13_city(mapParams,MapUtil.get(client,:a13_city))
    a14_street = ClientValidator.getA14_street(mapParams,MapUtil.get(client,:a14_street))
    a15_number = ClientValidator.getA15_number(mapParams,MapUtil.get(client,:a15_number))
    a16_compl1type = ClientValidator.getA16_compl1type(mapParams)
    a17_compl1desc = ClientValidator.getA17_compl1desc(mapParams)
    a18_compl2type = ClientValidator.getA18_compl2type(mapParams)
    a19_compl2desc = ClientValidator.getA19_compl2desc(mapParams)
    params = [a1_name,a2_type,a3_cpf,a4_cnpj,a5_birthdate,a6_doctype,
              a7_document,a8_gender,a9_email,a10_phone,a11_cep,a12_uf,
              a13_city,a14_street,a15_number,a16_compl1type,
              a17_compl1desc,a18_compl2type,a19_compl2desc]
    cond do
      (!(ClientService.update(id,params))) 
        -> MessagesUtil.systemMessage(100149)
      true -> MessagesUtil.systemMessage(201)
    end
  end 
  
end