defmodule ExApp.MailerConfigHandler do

  alias ExApp.MessagesUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  alias ExApp.MailerConfigService
  alias ExApp.GenericValidator
  alias ExApp.UserValidator
  alias ExApp.MailerConfigValidator
  alias ExApp.MailerConfig
  alias ExApp.UserService
  
  def objectClassName() do
    "Configuração Envio E-mail"
  end
  
  def objectTableName() do
    "mailerconfig"
  end
  
  def accessCategories() do
    ["admin_master","admin"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    provider = MailerConfigValidator.getProvider(mapParams)
    name = MailerConfigValidator.getName(mapParams)
    username = MailerConfigValidator.getUserName(mapParams)
    password = MailerConfigValidator.getPassword(mapParams)
    perMonth = MailerConfigValidator.getPerMonth(mapParams)
    perDay = MailerConfigValidator.getPerDay(mapParams)
    perHour = MailerConfigValidator.getPerHour(mapParams)
    perMinute = MailerConfigValidator.getPerMinute(mapParams)
    perSecond = MailerConfigValidator.getPerSecond(mapParams)
    replayTo = MailerConfigValidator.getReplayTo(mapParams)
    userId = UserValidator.getUserId(mapParams)
    ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([ownerId,userId,perSecond],1)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasLessThan([perMonth,perDay,perHour,perMinute],0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([provider,name,username,password,replayTo])) -> MessagesUtil.systemMessage(100023)
      (nil == UserService.loadById(userId)) -> MessagesUtil.systemMessage(100065)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,mailerconfig,mapParams) do
    ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == mailerconfig) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,mailerconfig) do
    cond do
      (!(id > 0) or nil == mailerconfig) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,mailerconfig) do
    cond do
      (!(id > 0) or nil == mailerconfig) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end

  def save(mapParams,_escapedAuth) do
    provider = MailerConfigValidator.getProvider(mapParams)
    name = MailerConfigValidator.getName(mapParams)
    username = MailerConfigValidator.getUserName(mapParams)
    password = MailerConfigValidator.getPassword(mapParams)
    position = GenericValidator.getPosition(mapParams)
    perMonth = MailerConfigValidator.getPerMonth(mapParams)
    perDay = MailerConfigValidator.getPerDay(mapParams)
    perHour = MailerConfigValidator.getPerHour(mapParams)
    perMinute = MailerConfigValidator.getPerMinute(mapParams)
    perSecond = MailerConfigValidator.getPerSecond(mapParams)
    replayTo = MailerConfigValidator.getReplayTo(mapParams)
    userId = UserValidator.getUserId(mapParams)
    ownerId = GenericValidator.getOwnerId(mapParams)
    params = [provider,name,username,password,position,
              perMonth,perDay,perHour,perMinute,perSecond,replayTo,userId,ownerId]
    newMailerConfig = MailerConfig.new(0,provider,name,username,password,position,
                                       perMonth,perDay,perHour,perMinute,
                                       perSecond,replayTo,nil,userId,ownerId)
    cond do
      (!(MailerConfigService.create(params))) -> MessagesUtil.systemMessage(100024)
      true -> MessagesUtil.systemMessage(200,[newMailerConfig])
    end
  end
  
  def update(id,mailerconfig,mapParams) do
    provider = MailerConfigValidator.getProvider(mapParams,MapUtil.get(mailerconfig,:provider))
    name = MailerConfigValidator.getName(mapParams,MapUtil.get(mailerconfig,:name))
    username = MailerConfigValidator.getUserName(mapParams,MapUtil.get(mailerconfig,:username))
    password = MailerConfigValidator.getPassword(mapParams,MapUtil.get(mailerconfig,:password))
    position = GenericValidator.getPosition(mapParams,MapUtil.get(mailerconfig,:position))
    perMonth = MailerConfigValidator.getPerMonth(mapParams,MapUtil.get(mailerconfig,:perMonth))
    perDay = MailerConfigValidator.getPerDay(mapParams,MapUtil.get(mailerconfig,:perDay))
    perHour = MailerConfigValidator.getPerHour(mapParams,MapUtil.get(mailerconfig,:perHour))
    perMinute = MailerConfigValidator.getPerMinute(mapParams,MapUtil.get(mailerconfig,:perMinute))
    perSecond = MailerConfigValidator.getPerSecond(mapParams,MapUtil.get(mailerconfig,:perSecond))
    replayTo = MailerConfigValidator.getReplayTo(mapParams,MapUtil.get(mailerconfig,:replayTo))
    params = [provider,name,username,password,position,perMonth,perDay,perHour,perMinute,perSecond,replayTo]
    cond do
      (!(MailerConfigService.update(id,params))) -> MessagesUtil.systemMessage(100025)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end