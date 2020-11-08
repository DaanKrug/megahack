defmodule ExApp.BasicController do

  defmacro __using__(_opts) do
  
    quote do
    
      use ExApp.BaseController
    
  	  alias ExApp.GenericValidator
  	  alias ExApp.StringUtil
  	  alias ExApp.NumberUtil
	  alias ExApp.AuthorizerUtil
	  alias ExApp.ReturnUtil
	  alias ExApp.MapUtil
	  alias ExApp.TimeSyncService
	  
	  defp validateAccessByHistoryAccess(ip,resource,token) do
	    cond do
	      (ip == "" or token == "") -> false
	      (!(AuthorizerUtil.validateAccessByHistoryAccess(ip,token,resource,30))) -> false
	      true -> AuthorizerUtil.storeHistoryAccess(ip,token,resource)
	    end
	  end
	  
      defp validateAccess(ip,accessCategories,token,ownerId,permission,skipValidateAccess \\false) do
	    cond do
	      (!(ownerId > 0) or token == "" or ip == "") -> false
	      (!AuthorizerUtil.isAuthenticated(ownerId,token,ip)) -> false
	      (skipValidateAccess) -> true
	      true -> AuthorizerUtil.validateAccess(ownerId,accessCategories,permission)
	    end
	  end
	  
	  defp getAdditionalConditionsOnLoad(conditions,ownerId,token,validatedAccess) do
	    conditions = "#{conditions}"
	    cond do
	      (!(ownerId > 0) and validatedAccess) -> nil
	      (String.contains?(conditions,"and ownerId =")) -> conditions
	      (!validatedAccess or (String.contains?(token,"_conferencist"))) -> conditions
	      true -> "#{conditions} #{AuthorizerUtil.getAdditionalConditionsOnLoad(ownerId)}"
	    end
	  end
	  
	  defp systemMessage(messageCode) do
	    cond do
	      (messageCode == 0) -> ReturnUtil.getOperationError("Erro de operação.")
	      (messageCode == 403) -> ReturnUtil.getOperationError("Falta de permissão de acesso ao recurso.")
	      (messageCode == 404) -> ReturnUtil.getOperationError("Recurso não existe.")
	      (messageCode == 412) -> ReturnUtil.getOperationError("Falha de pré condição.")
	      (messageCode == 429) -> ReturnUtil.getOperationError(
	                              "Excesso de Requisições ao Recurso. Tente novamente em alguns segundos.")
	      true -> systemMessage(0)
	    end
	  end
	  
	  defp updateDependencies(service,handler,authHandler,object,ownerId,id) do
	    objectNew = service.loadById(id)
	    service.updateDependencies(id,objectNew)
	  	authHandler.successfullyUpdated(ownerId,object,objectNew,handler.objectClassName())
	  end
	  
	  defp putSntptimestamp(array,newArray,sntptimestamp) do
	    cond do
	      (!(sntptimestamp > 0)) -> array
	      (nil == array || length(array) == 0) -> newArray
	      true -> putSntptimestamp(tl(array),
	                               newArray ++ [hd(array) |> Map.put(:sntptimestamp,sntptimestamp)],
	                               sntptimestamp)
	    end
	  end
	  
	  def fileS3Upload(conn,handler,authHandler) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    validation = handler.validateToUploadS3AndSave(conn.params)
	    permission = "#{handler.objectTableName()}_write"
	    result = cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategories(),token,ownerId,permission))) -> systemMessage(403)
	      (MapUtil.get(validation,:code) != 205) -> validation
	      true -> handler.uploadS3AndSave(conn.params)
	    end
	    cond do
	      (MapUtil.get(result,:code) != 200) -> result
	      true -> authHandler.successfullyCreated(ownerId,MapUtil.get(result,:object),handler.objectClassName())
	    end
	  end
	  
	  def save(conn,handler,authHandler,escapeAuth \\ false) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    validation = handler.validateToSave(conn.params)
	    permission = "#{handler.objectTableName()}_write"
	    result = cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) 
	        -> systemMessage(429)
	      (!escapeAuth and !(validateAccess(ip,handler.accessCategories(),token,ownerId,permission))) 
	        -> systemMessage(403)
	      (MapUtil.get(validation,:code) != 205) -> validation
	      true -> handler.save(conn.params,escapeAuth)
	    end
	    cond do
	      (MapUtil.get(result,:code) != 200) -> result
	      true -> authHandler.successfullyCreated(ownerId,MapUtil.get(result,:object),
	                                              handler.objectClassName())
	    end
	  end
	  
	  def update(conn,handler,authHandler,service,id) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    object = service.loadById(id)
	    validation = handler.validateToUpdate(id,object,conn.params)
	    permission = "#{handler.objectTableName()}_write"
	    skipValidateAccess = (ownerId == id) and Enum.member?(["user_write","conconferencist_write"],permission)
	    result = cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategories(),token,ownerId,permission,skipValidateAccess))) 
	        -> systemMessage(403)
	      (nil == object) -> systemMessage(412)
	      (!skipValidateAccess 
	        and !(AuthorizerUtil.validateOwnership(object,ownerId,token,permission))) 
	          -> authHandler.unAuthorizedUpdate(ownerId,object,handler.objectClassName())
	      (MapUtil.get(validation,:code) != 205) -> validation
	      true -> handler.update(id,object,conn.params)
	    end
	    cond do
	      (MapUtil.get(result,:code) != 201) -> result
	      true -> updateDependencies(service,handler,authHandler,object,ownerId,id)
	    end
	  end
	  
	  def edit(conn,handler,service,id) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    permission = handler.objectTableName()
	    sntptimestamp = cond do
	      (!(GenericValidator.getBool(conn.params,"getsntptimestamp",false))) -> 0
	      true -> GenericValidator.getLanguage(conn.params) 
	                |> TimeSyncService.getRightTime()
	    end
	    cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategories(),token,ownerId,permission))) -> systemMessage(403)
	      (!(id > 0)) -> systemMessage(412)
	      true -> service.loadForEdit(id) |> Map.put(:sntptimestamp,sntptimestamp)
	    end
	  end
	  
	  def loadAll(conn,handler,service,page,rows) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    permission = handler.objectTableName()
	    validatedAcess = validateAccess(ip,handler.accessCategories(),token,ownerId,permission) 
	    conditions = GenericValidator.getConditions(conn.params)
	                   |> getAdditionalConditionsOnLoad(ownerId,token,validatedAcess)
	    deletedAt = AuthorizerUtil.getDeletedAt(token,ownerId)
	    sntptimestamp = cond do
	      (!(GenericValidator.getBool(conn.params,"getsntptimestamp",false))) -> 0
	      true -> GenericValidator.getLanguage(conn.params) 
	                |> TimeSyncService.getRightTime()
	    end
	    cond do
	      (nil == conditions or page == 0 or rows == 0) -> systemMessage(412)
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) 
	        -> systemMessage(429)
	      (!validatedAcess) 
	        -> service.loadAllForPublic(page,rows,conditions,deletedAt,conn.params)
	                     |> putSntptimestamp([],sntptimestamp)
	      true -> service.loadAll(page,rows,conditions,deletedAt,conn.params)
	                |> putSntptimestamp([],sntptimestamp)
	    end
	  end
	  
	  def delete(conn,handler,authHandler,service,id) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    object = service.loadById(id)
	    validation = handler.validateToDelete(id,object)
	    permission = "#{handler.objectTableName()}_write"
	    cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategories(),token,ownerId,permission))) -> systemMessage(403)
	      (nil == object) -> systemMessage(412)
	      (!(AuthorizerUtil.validateOwnership(object,ownerId,token,permission))) 
	        -> authHandler.unAuthorizedDelete(ownerId,object,handler.objectClassName())
	      (MapUtil.get(validation,:code) != 205) -> validation
	      (!(service.delete(id))) -> systemMessage(0)
          true -> authHandler.successfullyDeleted(ownerId,object,handler.objectClassName())
	    end
	  end
	  
	  def unDrop(conn,handler,authHandler,service,id) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    object = service.loadById(id)
	    validation = handler.validateToRestore(id,object)
	    permission = "#{handler.objectTableName()}_write"
	    cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategoriesAuditor(),token,ownerId,permission))) -> systemMessage(403)
	      (!(id > 0) or nil == object) -> systemMessage(412)
	      (MapUtil.get(validation,:code) != 205) -> validation
	      (!(service.unDrop(id))) -> systemMessage(0)
          true -> authHandler.successfullyRestored(ownerId,service.loadById(id),handler.objectClassName())
	    end
	  end
	  
	  def trullyDrop(conn,handler,authHandler,service,id) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    object = service.loadById(id)
	    validation = handler.validateToDelete(id,object)
	    permission = "#{handler.objectTableName()}_write"
	    cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategoriesAuditor(),token,ownerId,permission))) -> systemMessage(403)
	      (!(id > 0) or nil == object) -> systemMessage(412)
	      (MapUtil.get(validation,:code) != 205) -> validation
	      (!(service.trullyDrop(id))) -> systemMessage(0)
          true -> authHandler.successfullyTrullyDeleted(ownerId,object,handler.objectClassName())
	    end
	  end
	  
	  def loadReport(conn,handler) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    token = GenericValidator.getToken(conn.params)
	    ownerId = GenericValidator.getOwnerId(conn.params)
	    permission = handler.objectTableName()
	    cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),token))) -> systemMessage(429)
	      (!(validateAccess(ip,handler.accessCategories(),token,ownerId,permission))) -> systemMessage(403)
	      true -> handler.loadReport(conn.params)
	    end
	  end
  
    end
  end
end
