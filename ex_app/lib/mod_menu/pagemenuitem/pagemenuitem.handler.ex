defmodule ExApp.PageMenuItemHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.PageMenuService
  alias ExApp.PageMenuItemService
  alias ExApp.GenericValidator
  alias ExApp.PageMenuValidator
  alias ExApp.PageMenuItemValidator
  alias ExApp.PageMenuItem
  alias ExApp.PageMenuItemFileService
  
  
  def objectClassName() do
    "Item Menu"
  end
  
  def objectTableName() do
    "pagemenuitem"
  end
  
  def accessCategories() do
    ["admin_master","admin","enroll"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master","admin","system_auditor","enroll"]
  end
  
  def validateToSave(mapParams) do
    name = PageMenuValidator.getName(mapParams)
    content = PageMenuItemValidator.getContent(mapParams)
    position = GenericValidator.getPosition(mapParams)
    pageMenuId = PageMenuItemValidator.getPageMenuId(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([ownerId,position,pageMenuId],1)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name,content])) -> MessagesUtil.systemMessage(100035)
      (nil == PageMenuService.loadById(pageMenuId)) -> MessagesUtil.systemMessage(100034)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,pagemenuitem,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == pagemenuitem) 
        -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,pagemenuitem) do
    cond do
      (!(id > 0) or nil == pagemenuitem) -> MessagesUtil.systemMessage(412)
      (PageMenuItemFileService.pageMenuItemIsIn(id)) -> MessagesUtil.systemMessage(100113)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,pagemenuitem) do
    cond do
      (!(id > 0) or nil == pagemenuitem) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = PageMenuValidator.getName(mapParams)
    content = PageMenuItemValidator.getContent(mapParams)
    position = GenericValidator.getPosition(mapParams)
    active = GenericValidator.getBool(mapParams,"active",false)
    pageMenuId = PageMenuItemValidator.getPageMenuId(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
	params = [name,content,position,active,pageMenuId,ownerId]
	newPageMenuItem = PageMenuItem.new(0,name,content,position,active,pageMenuId,ownerId)
    cond do
      (!(PageMenuItemService.create(params))) 
        -> MessagesUtil.systemMessage(100036)
      true -> MessagesUtil.systemMessage(200,[newPageMenuItem])
    end
  end
  
  def update(id,pagemenuitem,mapParams) do
    name = PageMenuValidator.getName(mapParams,MapUtil.get(pagemenuitem,:name))
    content = PageMenuItemValidator.getContent(mapParams,MapUtil.get(pagemenuitem,:content))
    position = GenericValidator.getPosition(mapParams,MapUtil.get(pagemenuitem,:position))
    oldActive = (MapUtil.get(pagemenuitem,:active) == 1)
    active = GenericValidator.getBool(mapParams,"active",oldActive)
    params = [name,content,position,active]
    cond do
      (!(PageMenuItemService.update(id,params))) 
        -> MessagesUtil.systemMessage(100037)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end