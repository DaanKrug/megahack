defmodule ExApp.FileHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.FileService
  alias ExApp.GenericValidator
  alias ExApp.FileValidator
  alias ExApp.File
  alias ExApp.S3FileHandler
  
  def objectClassName() do
    "Arquivo"
  end 
  
  def objectTableName() do
    "file"
  end
  
  def accessCategories() do
    ["admin_master","admin"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor"]
  end
  
  def validateToUploadS3AndSave(mapParams) do
    name = FileValidator.getName(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name])) -> MessagesUtil.systemMessage(100031)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToSave(mapParams) do
    name = FileValidator.getName(mapParams)
    link = FileValidator.getLink(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name,link])) -> MessagesUtil.systemMessage(100026)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,file,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == file) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,file) do
    cond do
      (!(id > 0) or nil == file) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,file) do
    cond do
      (!(id > 0) or nil == file) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def uploadS3AndSave(mapParams) do
    fileName = FileValidator.getFileName(mapParams)
    name = FileValidator.getName(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	fileBase64 = MapUtil.get(mapParams,:file)
	link = cond do
	  (nil == fileName) -> nil
	  true -> S3FileHandler.validateAndUploadS3(fileName,fileBase64,ownerId)
	end
    cond do
      (nil == link) -> MessagesUtil.systemMessage(100027)
      (!(FileService.create([name,link,ownerId]))) -> MessagesUtil.systemMessage(100027)
      true -> MessagesUtil.systemMessage(200,[File.new(0,name,link,ownerId)])
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = FileValidator.getName(mapParams)
    link = FileValidator.getLink(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(FileService.create([name,link,ownerId]))) -> MessagesUtil.systemMessage(100027)
      true -> MessagesUtil.systemMessage(200,[File.new(0,name,link,ownerId)])
    end
  end
  
  def update(id,file,mapParams) do
    name = FileValidator.getName(mapParams,MapUtil.get(file,:name))
    link = FileValidator.getLink(mapParams,MapUtil.get(file,:link))
    cond do
      (!(FileService.update(id,[name,link]))) -> MessagesUtil.systemMessage(100028)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end
