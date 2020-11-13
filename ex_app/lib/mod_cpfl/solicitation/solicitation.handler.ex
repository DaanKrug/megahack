defmodule ExApp.SolicitationHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.Solicitation
  alias ExApp.GenericValidator
  alias ExApp.SolicitationValidator
  alias ExApp.SolicitationService 
  alias ExApp.ClientService
  alias ExApp.ConsumerunitService
  
  
  def objectClassName() do
    "Solicitação de Nova Ligação"
  end 
  
  def objectTableName() do
    "solicitation"
  end
  
  def accessCategories() do
    ["admin","admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["system_auditor","admin","admin_master","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    id = GenericValidator.getId(mapParams)
    a1_name = SolicitationValidator.getA1_name(mapParams)
    a3_cpf = SolicitationValidator.getA3_cpf(mapParams)
    a4_cnpj = SolicitationValidator.getA4_cnpj(mapParams)
    a2_caracteristic = SolicitationValidator.getA2_caracteristic(mapParams)
    a5_cep = SolicitationValidator.getA5_cep(mapParams)
    a6_uf = SolicitationValidator.getA6_uf(mapParams)
    a7_city = SolicitationValidator.getA7_city(mapParams)
    a8_street = SolicitationValidator.getA8_street(mapParams)
    a14_reference = SolicitationValidator.getA14_reference(mapParams)
    a15_clientid = SolicitationValidator.getA15_clientid(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_name,a2_caracteristic,a5_cep,a6_uf,a7_city,a8_street,a14_reference]
    cond do
      (!(ownerId > 0) and !(id == -1 and ownerId == 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty(params)) -> MessagesUtil.systemMessage(480,[objectClassName()])
      (a3_cpf == "" and a4_cnpj == "") -> MessagesUtil.systemMessage(480,[objectClassName()])
      (SanitizerUtil.hasLessThan([a15_clientid],1)) 
        -> MessagesUtil.systemMessage(480,[objectClassName()])
      (nil == ClientService.loadById(a15_clientid)) 
        -> MessagesUtil.systemMessage(100150)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,solicitation,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == solicitation) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,solicitation) do
    cond do
      (!(id > 0) or nil == solicitation) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,solicitation) do
    cond do
      (!(id > 0) or nil == solicitation) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    a1_name = SolicitationValidator.getA1_name(mapParams)
    a3_cpf = SolicitationValidator.getA3_cpf(mapParams)
    a4_cnpj = SolicitationValidator.getA4_cnpj(mapParams)
    a2_caracteristic = SolicitationValidator.getA2_caracteristic(mapParams)
    a5_cep = SolicitationValidator.getA5_cep(mapParams)
    a6_uf = SolicitationValidator.getA6_uf(mapParams)
    a7_city = SolicitationValidator.getA7_city(mapParams)
    a8_street = SolicitationValidator.getA8_street(mapParams)
    a9_number = SolicitationValidator.getA9_number(mapParams)
    a10_compl1type = SolicitationValidator.getA10_compl1type(mapParams)
    a11_compl1desc = SolicitationValidator.getA11_compl1desc(mapParams)
    a12_compl2type = SolicitationValidator.getA12_compl2type(mapParams)
    a13_compl2desc = SolicitationValidator.getA13_compl2desc(mapParams)
    a14_reference = SolicitationValidator.getA14_reference(mapParams)
    a15_clientid = SolicitationValidator.getA15_clientid(mapParams)
    active = GenericValidator.getBool(mapParams,"active",false)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,a6_uf,a7_city,
	          a8_street,a9_number,a10_compl1type,a11_compl1desc,a12_compl2type,
	          a13_compl2desc,a14_reference,a15_clientid,active,ownerId]
	newObject = Solicitation.new(0,a1_name,a3_cpf,a4_cnpj,a2_caracteristic,a5_cep,
	                             a6_uf,a7_city,a8_street,a9_number,a10_compl1type,a11_compl1desc,
	                             a12_compl2type,a13_compl2desc,a14_reference,
	                             a15_clientid,active,ownerId)
    cond do
      (!(SolicitationService.create(params))) 
        -> MessagesUtil.systemMessage(100151)
      true -> MessagesUtil.systemMessage(200,[newObject])
    end
  end
  
  def update(id,solicitation,mapParams) do
    a2_caracteristic = SolicitationValidator.getA2_caracteristic(mapParams,
                                               MapUtil.get(solicitation,:a2_caracteristic))
    a5_cep = SolicitationValidator.getA5_cep(mapParams,MapUtil.get(solicitation,:a5_cep))
    a6_uf = SolicitationValidator.getA6_uf(mapParams,MapUtil.get(solicitation,:a6_uf))
    a7_city = SolicitationValidator.getA7_city(mapParams,MapUtil.get(solicitation,:a7_city))
    a8_street = SolicitationValidator.getA8_street(mapParams,MapUtil.get(solicitation,:a8_street))
    a9_number = SolicitationValidator.getA9_number(mapParams)
    a10_compl1type = SolicitationValidator.getA10_compl1type(mapParams)
    a11_compl1desc = SolicitationValidator.getA11_compl1desc(mapParams)
    a12_compl2type = SolicitationValidator.getA12_compl2type(mapParams)
    a13_compl2desc = SolicitationValidator.getA13_compl2desc(mapParams)
    a14_reference = SolicitationValidator.getA14_reference(mapParams,MapUtil.get(solicitation,:a14_reference))
    oldActive = MapUtil.get(solicitation,:active)
    active = GenericValidator.getBool(mapParams,"active",oldActive)
    params = [a2_caracteristic,a5_cep,a6_uf,a7_city,a8_street,a9_number,a10_compl1type,
              a11_compl1desc,a12_compl2type,a13_compl2desc,a14_reference,active]
    cond do
      (!(SolicitationService.update(id,params))) 
        -> MessagesUtil.systemMessage(100152)
      (oldActive != active and active) -> createConsumerUnit(id) 
      (oldActive != active and !active) -> dropConsumerUnit(id) 
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
  defp createConsumerUnit(id) do
    solicitation = SolicitationService.loadById(id)
    params = [
      MapUtil.get(solicitation,:a1_name),
      MapUtil.get(solicitation,:a3_cpf),
      MapUtil.get(solicitation,:a4_cnpj),
      MapUtil.get(solicitation,:a2_caracteristic),
      MapUtil.get(solicitation,:a5_cep),
      MapUtil.get(solicitation,:a6_uf),
      MapUtil.get(solicitation,:a7_city),
      MapUtil.get(solicitation,:a8_street),
      MapUtil.get(solicitation,:a9_number),
      MapUtil.get(solicitation,:a10_compl1type),
      MapUtil.get(solicitation,:a11_compl1desc),
      MapUtil.get(solicitation,:a12_compl2type),
      MapUtil.get(solicitation,:a13_compl2desc),
      MapUtil.get(solicitation,:a14_reference),
      MapUtil.get(solicitation,:a15_clientid),
      id,
      MapUtil.get(solicitation,:ownerId)
    ]
    cond do
      (ConsumerunitService.create(params)) 
        -> MessagesUtil.systemMessage(201)
      true -> MessagesUtil.systemMessage(100154)
    end
  end
  
  defp dropConsumerUnit(id) do
    cond do
      (ConsumerunitService.deleteBySolicitationId(id)) 
        -> MessagesUtil.systemMessage(201)
      true -> MessagesUtil.systemMessage(100155)
    end
  end
  
end



