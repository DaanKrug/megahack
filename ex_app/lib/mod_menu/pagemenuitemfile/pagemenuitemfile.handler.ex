defmodule ExApp.PageMenuItemFileHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.MapUtil
  alias ExApp.MessagesUtil
  alias ExApp.FileService
  alias ExApp.PageMenuItemService
  alias ExApp.PageMenuItemFileService
  alias ExApp.GenericValidator
  alias ExApp.FileValidator
  alias ExApp.PageMenuItemFileValidator
  alias ExApp.PageMenuItemFile
  
  def objectClassName() do
    "Arquivo Item Menu"
  end 
  
  def objectTableName() do
    "pagemenuitemfile"
  end
  
  def accessCategories() do
    ["admin_master","admin","enroll"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor","enroll"]
  end
  
  def validateToSave(mapParams) do
    position = GenericValidator.getPosition(mapParams)
    fileId = FileValidator.getFileId(mapParams)
    pageMenuItemId = PageMenuItemFileValidator.getPageMenuItemId(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (SanitizerUtil.hasLessThan([ownerId,position,fileId,pageMenuItemId],1)) -> MessagesUtil.systemMessage(412)
      (nil == PageMenuItemService.loadById(pageMenuItemId)) -> MessagesUtil.systemMessage(100038)
      (nil == FileService.loadById(fileId)) -> MessagesUtil.systemMessage(100041)
      (PageMenuItemFileService.alreadyExists(0,pageMenuItemId,fileId,deletedAt)) -> MessagesUtil.systemMessage(100042)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,pagemenuitemfile) do
    cond do
      (!(id > 0) or nil == pagemenuitemfile) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,pagemenuitemfile) do
    pageMenuItemId = MapUtil.get(pagemenuitemfile,:pageMenuItemId)
    fileId = MapUtil.get(pagemenuitemfile,:fileId)
    deletedAt = AuthorizerUtil.getDeletedAt(nil,nil)
    cond do
      (!(id > 0) or nil == pagemenuitemfile) -> MessagesUtil.systemMessage(412)
      (PageMenuItemFileService.alreadyExists(id,pageMenuItemId,fileId,deletedAt)) -> MessagesUtil.systemMessage(100042)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    position = GenericValidator.getPosition(mapParams)
    fileId = FileValidator.getFileId(mapParams)
    pageMenuItemId = PageMenuItemFileValidator.getPageMenuItemId(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	file = FileService.loadById(fileId)
	name = MapUtil.get(file,:name)
	fileLink = MapUtil.get(file,:link)
	params = [name,position,fileId,fileLink,pageMenuItemId,ownerId]
	newPageMenuItemFile = PageMenuItemFile.new(0,name,position,fileId,fileLink,pageMenuItemId,ownerId)
    cond do
      (!(PageMenuItemFileService.create(params))) -> MessagesUtil.systemMessage(100039)
      true -> MessagesUtil.systemMessage(200,[newPageMenuItemFile])
    end
  end
  
end
