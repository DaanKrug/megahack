defmodule ExApp.ExternalController do

  defmacro __using__(_opts) do
  
    quote do
    
      use ExApp.BasicController
    
  	  alias ExApp.GenericValidator
	  alias ExApp.MapUtil
	  
	  def externalSave(conn,handler,authHandler) do
	    {:ok, _body, conn} = Plug.Conn.read_body(conn)
	    ip = GenericValidator.getIp(conn.remote_ip)
	    users = cond do
	      (!(validateAccessByHistoryAccess(ip,handler.objectClassName(),"external_access"))) -> []
	      true -> authHandler.login(conn.params,ip)
	    end
	    auth = (length(users) > 0 and MapUtil.get(Enum.at(users,0),:id) > 0)
	    response = cond do
	      (auth) -> save(conn,handler,authHandler)
	      (length(users) == 0) -> systemMessage(429)
	      true -> systemMessage(403)
	    end
	    if(auth) do
	      authHandler.logoff(conn.params)
	    end
	    response
	  end
	  
	end
	
  end
  
end