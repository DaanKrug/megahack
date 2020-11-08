defmodule ExApp.ImageHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.ImageService
  alias ExApp.GenericValidator
  alias ExApp.ImageValidator
  alias ExApp.Image
  
  def objectClassName() do
    "Imagem"
  end
  
  def objectTableName() do
    "image"
  end
  
  def accessCategories() do
    ["admin_master","admin","enroll"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor","enroll"]
  end
  
  def validateToSave(mapParams) do
    name = ImageValidator.getName(mapParams)
    link = ImageValidator.getLink(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name,link])) -> MessagesUtil.systemMessage(100026)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,image,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == image) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,image) do
    cond do
      (!(id > 0) or nil == image) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,image) do
    cond do
      (!(id > 0) or nil == image) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = ImageValidator.getName(mapParams)
    link = ImageValidator.getLink(mapParams)
    description = ImageValidator.getDescription(mapParams)
    forPublic = GenericValidator.getBool(mapParams,"forPublic",false)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ImageService.create([name,link,description,forPublic,ownerId]))) -> MessagesUtil.systemMessage(100029)
      true -> MessagesUtil.systemMessage(200,[Image.new(0,name,link,description,forPublic,ownerId)])
    end
  end
  
  def update(id,image,mapParams) do
    name = ImageValidator.getName(mapParams,MapUtil.get(image,:name))
    link = ImageValidator.getLink(mapParams,MapUtil.get(image,:link))
    description = ImageValidator.getDescription(mapParams,MapUtil.get(image,:description))
    forPublic = GenericValidator.getBool(mapParams,"forPublic",MapUtil.get(image,:forPublic))
    cond do
      (!(ImageService.update(id,[name,link,description,forPublic]))) -> MessagesUtil.systemMessage(100030)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end
