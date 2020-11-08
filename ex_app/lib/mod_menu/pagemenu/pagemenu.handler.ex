defmodule ExApp.PageMenuHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.PageMenuService
  alias ExApp.GenericValidator
  alias ExApp.PageMenuValidator
  alias ExApp.PageMenu
  alias ExApp.PageMenuItemService
  
  def objectClassName() do
    "Menu"
  end
  
  def objectTableName() do
    "pagemenu"
  end
  
  def accessCategories() do
    ["admin_master","admin"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor"]
  end
  
  def validateToSave(mapParams) do
    name = PageMenuValidator.getName(mapParams)
    position = GenericValidator.getPosition(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([ownerId,position],1)) 
        -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name])) 
        -> MessagesUtil.systemMessage(100031)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,pagemenu,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == pagemenu) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,pagemenu) do
    cond do
      (!(id > 0) or nil == pagemenu) -> MessagesUtil.systemMessage(412)
      (PageMenuItemService.pageMenuIsIn(id)) -> MessagesUtil.systemMessage(100112)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,pagemenu) do
    cond do
      (!(id > 0) or nil == pagemenu) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = PageMenuValidator.getName(mapParams)
    position = GenericValidator.getPosition(mapParams)
    active = GenericValidator.getBool(mapParams,"active",false)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [name,position,active,ownerId]
	newPageMenu = PageMenu.new(0,name,position,active,ownerId)
    cond do
      (!(PageMenuService.create(params))) 
        -> MessagesUtil.systemMessage(100032)
      true -> MessagesUtil.systemMessage(200,[newPageMenu])
    end
  end
  
  def update(id,pagemenu,mapParams) do
    name = PageMenuValidator.getName(mapParams,MapUtil.get(pagemenu,:name))
    position = GenericValidator.getPosition(mapParams,MapUtil.get(pagemenu,:position))
    active = GenericValidator.getBool(mapParams,"active",MapUtil.get(pagemenu,:active))
    params = [name,position,active]
    cond do
      (!(PageMenuService.update(id,params))) -> MessagesUtil.systemMessage(100033)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end
