defmodule ExApp.AdditionaluserinfoController do
 
  import Plug.Conn
  use Plug.Router
  use ExApp.BasicController
  alias ExApp.NumberUtil
  alias ExApp.AdditionaluserinfoHandler, as: Handler
  alias ExApp.AdditionaluserinfoService, as: Service
  alias ExApp.AuthHandler, as: AuthHandler
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)
  
  post "/" do
    sendResponse(conn,save(conn,Handler,AuthHandler))
  end

  post "/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,edit(conn,Handler,Service,id))
  end
  
  post "/:page/:rows" do
    page = NumberUtil.toInteger(StringUtil.decodeUri("#{page}"))
    rows = NumberUtil.toInteger(StringUtil.decodeUri("#{rows}"))
    sendResponse(conn,loadAll(conn,Handler,Service,page,rows))
  end
  
  put "/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,update(conn,Handler,AuthHandler,Service,id))
  end
  
  match _ do
    notFound(conn)
  end
  
end