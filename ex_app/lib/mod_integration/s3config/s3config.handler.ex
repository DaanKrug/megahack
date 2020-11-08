defmodule ExApp.S3ConfigHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.S3ConfigService
  alias ExApp.GenericValidator
  alias ExApp.S3ConfigValidator
  alias ExApp.S3Config
  alias ExApp.AuthorizerUtil
  
  def objectClassName() do
    "Configuração AWS S3"
  end 
  
  def objectTableName() do
    "s3config"
  end
  
  def accessCategories() do
    ["admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master"]
  end
  
  def validateToSave(mapParams) do
    bucketName = S3ConfigValidator.getBucketName(mapParams)
    bucketUrl = S3ConfigValidator.getBucketUrl(mapParams)
    region = S3ConfigValidator.getRegion(mapParams)
    version = S3ConfigValidator.getVersion(mapParams)
    key = S3ConfigValidator.getKey(mapParams)
    secret = S3ConfigValidator.getSecret(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([bucketName,bucketUrl,region,version,key,secret])) -> MessagesUtil.systemMessage(100129)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,s3config,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
	activeOld = MapUtil.get(s3config,:active)
	activeNew = GenericValidator.getBool(mapParams,"active",activeOld)
	deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == s3config) -> MessagesUtil.systemMessage(412)
      (activeNew and activeNew != activeOld and S3ConfigService.alreadyHasActive(id,deletedAt)) -> MessagesUtil.systemMessage(100132)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,s3config) do
    cond do
      (!(id > 0) or nil == s3config) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,s3config) do
    cond do
      (!(id > 0) or nil == s3config) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    bucketName = S3ConfigValidator.getBucketName(mapParams)
    bucketUrl = S3ConfigValidator.getBucketUrl(mapParams)
    region = S3ConfigValidator.getRegion(mapParams)
    version = S3ConfigValidator.getVersion(mapParams)
    key = S3ConfigValidator.getKey(mapParams)
    secret = S3ConfigValidator.getSecret(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(S3ConfigService.create([bucketName,bucketUrl,region,version,key,secret,false,ownerId]))) -> MessagesUtil.systemMessage(100130)
      true -> MessagesUtil.systemMessage(200,[S3Config.new(0,bucketName,bucketUrl,region,version,key,secret,false,ownerId)])
    end
  end
  
  def update(id,s3config,mapParams) do
    bucketName = S3ConfigValidator.getBucketName(mapParams,MapUtil.get(s3config,:bucketName))
    bucketUrl = S3ConfigValidator.getBucketUrl(mapParams,MapUtil.get(s3config,:bucketUrl))
    region = S3ConfigValidator.getRegion(mapParams,MapUtil.get(s3config,:region))
    version = S3ConfigValidator.getVersion(mapParams,MapUtil.get(s3config,:version))
    key = S3ConfigValidator.getKey(mapParams,MapUtil.get(s3config,:key))
    secret = S3ConfigValidator.getSecret(mapParams,MapUtil.get(s3config,:secret))
    active = GenericValidator.getBool(mapParams,"active",MapUtil.get(s3config,:active))
    cond do
      (!(S3ConfigService.update(id,[bucketName,bucketUrl,region,version,key,secret,active]))) -> MessagesUtil.systemMessage(100131)
      (active and !(startDynamicConfigurations())) -> MessagesUtil.systemMessage(100133)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
  def startDynamicConfigurations() do
    S3ConfigService.setS3Config()
  end
  
end
