defmodule ExApp.ModuleHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.ModuleService
  alias ExApp.GenericValidator
  alias ExApp.ModuleValidator
  alias ExApp.Module
  
  def objectClassName() do
    "Módulo"
  end
  
  def objectTableName() do
    "module"
  end
  
  def accessCategories() do
    ["admin_master"]
  end
  
  def accessCategoriesAuditor() do
    ["admin_master"]
  end
  
  def validateToSave(mapParams) do
    name = ModuleValidator.getName(mapParams)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ownerId > 0)) -> MessagesUtil.systemMessage(412)
      (SanitizerUtil.hasEmpty([name])) -> MessagesUtil.systemMessage(100031)
      (ModuleService.alreadyExists(0,name,AuthorizerUtil.getDeletedAt(nil,nil))) -> MessagesUtil.systemMessage(100049)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToUpdate(id,module,mapParams) do
	ownerId = GenericValidator.getOwnerId(mapParams)
	newName = ModuleValidator.getName(mapParams,MapUtil.get(module,:name))
    cond do
      (SanitizerUtil.hasLessThan([id,ownerId],1) or nil == module) -> MessagesUtil.systemMessage(412)
      (ModuleService.alreadyExists(id,newName,AuthorizerUtil.getDeletedAt(nil,nil))) -> MessagesUtil.systemMessage(100049)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToDelete(id,module) do
    cond do
      (!(id > 0) or nil == module) -> MessagesUtil.systemMessage(412)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def validateToRestore(id,module) do
    cond do
      (!(id > 0) or nil == module) -> MessagesUtil.systemMessage(412)
      (ModuleService.alreadyExists(id,MapUtil.get(module,:name),AuthorizerUtil.getDeletedAt(nil,nil))) -> MessagesUtil.systemMessage(100049)
      true -> MessagesUtil.systemMessage(205)
    end
  end
  
  def save(mapParams,_escapedAuth) do
    name = ModuleValidator.getName(mapParams)
    active = GenericValidator.getBool(mapParams,"active",true)
	ownerId = GenericValidator.getOwnerId(mapParams)
    cond do
      (!(ModuleService.create([name,active,ownerId]))) -> MessagesUtil.systemMessage(100047)
      true -> MessagesUtil.systemMessage(200,[Module.new(0,name,active,ownerId)])
    end
  end
  
  def update(id,module,mapParams) do
    name = ModuleValidator.getName(mapParams,MapUtil.get(module,:name))
    active = GenericValidator.getBool(mapParams,"active",MapUtil.get(module,:active))
    cond do
      (!(ModuleService.update(id,[name,active]))) -> MessagesUtil.systemMessage(100048)
      true -> MessagesUtil.systemMessage(201)
    end
  end
  
end
