defmodule ExApp.AppConfigHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.AppConfigService
  alias ExApp.GenericValidator
  alias ExApp.AppConfigValidator
  alias ExApp.AppConfig
  
  def objectClassName() do
    "Configuração da Aplicação"
  end
  
  def objectTableName() do
    "appconfig"
  end
  
  def accessCategories() do
    ["admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master"]
  end
  
  def validateToSave(mapParams) do
    name = AppConfigValidator.getName(mapParams)
    description = AppConfigValidator.getDescription(mapParams)
    site = AppConfigValidator.getSite(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name,description,site])) -> MessagesUtil.systemMessage(100054)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,config,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
	activeOld = MapUtil.get(config,:active)
	activeNew = GenericValidator.getBool(mapParams,"active",activeOld)
	deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == config) -> MessagesUtil.systemMessage(412)
      (activeNew and activeNew != activeOld and AppConfigService.alreadyHasActive(id,deletedAt)) 
        -> MessagesUtil.systemMessage(100055)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,config) do
    cond do
      (!(id > 0) or nil == config) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,config) do
    cond do
      (!(id > 0) or nil == config) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = AppConfigValidator.getName(mapParams)
    description = AppConfigValidator.getDescription(mapParams)
    site = AppConfigValidator.getSite(mapParams)
    usePricingPolicy = GenericValidator.getBool(mapParams,"usePricingPolicy",false)
    pricingPolicy = AppConfigValidator.getPricingPolicy(mapParams)
    usePrivacityPolicy = GenericValidator.getBool(mapParams,"usePrivacityPolicy",false)
    privacityPolicy = AppConfigValidator.getPrivacityPolicy(mapParams)
    useUsetermsPolicy = GenericValidator.getBool(mapParams,"useUsetermsPolicy",false)
    usetermsPolicy = AppConfigValidator.getUsetermsPolicy(mapParams)
    useUsecontractPolicy = GenericValidator.getBool(mapParams,"useUsecontractPolicy",false)
    usecontractPolicy = AppConfigValidator.getUsecontractPolicy(mapParams)
    useAuthorInfo = GenericValidator.getBool(mapParams,"useAuthorInfo",false)
    authorInfo = AppConfigValidator.getAuthorInfo(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
              useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
              useAuthorInfo,authorInfo,false,ownerId]
	newAppConfig = AppConfig.new(0,name,description,site,usePricingPolicy,pricingPolicy,
	                             usePrivacityPolicy,privacityPolicy,useUsetermsPolicy,usetermsPolicy,
	                             useUsecontractPolicy,usecontractPolicy,useAuthorInfo,authorInfo,false,ownerId)
    cond do
      (!(AppConfigService.create(params))) -> MessagesUtil.systemMessage(100056)
      true -> MessagesUtil.systemMessage(200,[newAppConfig])
    end
  end
  
  def update(id,config,mapParams) do
    name = AppConfigValidator.getName(mapParams,MapUtil.get(config,:name))
    description = AppConfigValidator.getDescription(mapParams,MapUtil.get(config,:description))
    site = AppConfigValidator.getSite(mapParams,MapUtil.get(config,:site))
    usePricingPolicy = GenericValidator.getBool(mapParams,"usePricingPolicy",MapUtil.get(config,:usePricingPolicy))
    pricingPolicy = AppConfigValidator.getPricingPolicy(mapParams,MapUtil.get(config,:pricingPolicy))
    usePrivacityPolicy = GenericValidator.getBool(mapParams,"usePrivacityPolicy",
                                                  MapUtil.get(config,:usePrivacityPolicy))
    privacityPolicy = AppConfigValidator.getPrivacityPolicy(mapParams,MapUtil.get(config,:privacityPolicy))
    useUsetermsPolicy = GenericValidator.getBool(mapParams,"useUsetermsPolicy",MapUtil.get(config,:useUsetermsPolicy))
    usetermsPolicy = AppConfigValidator.getUsetermsPolicy(mapParams,MapUtil.get(config,:usetermsPolicy))
    useUsecontractPolicy = GenericValidator.getBool(mapParams,"useUsecontractPolicy",
                                                    MapUtil.get(config,:useUsecontractPolicy))
    usecontractPolicy = AppConfigValidator.getUsecontractPolicy(mapParams,MapUtil.get(config,:usecontractPolicy))
    useAuthorInfo = GenericValidator.getBool(mapParams,"useAuthorInfo",MapUtil.get(config,:useAuthorInfo))
    authorInfo = AppConfigValidator.getAuthorInfo(mapParams,MapUtil.get(config,:authorInfo))
    active = GenericValidator.getBool(mapParams,"active",MapUtil.get(config,:active))
    params = [name,description,site,usePricingPolicy,pricingPolicy,usePrivacityPolicy,privacityPolicy,
              useUsetermsPolicy,usetermsPolicy,useUsecontractPolicy,usecontractPolicy,
              useAuthorInfo,authorInfo,active]
    cond do
      (!(AppConfigService.update(id,params))) -> MessagesUtil.systemMessage(100057)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end
