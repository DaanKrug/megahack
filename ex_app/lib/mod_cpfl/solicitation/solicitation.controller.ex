defmodule ExApp.SolicitationController do
 
  import Plug.Conn
  use Plug.Router
  use ExApp.BasicController
  alias ExApp.NumberUtil
  alias ExApp.SolicitationHandler, as: Handler
  alias ExApp.SolicitationService, as: Service
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
  
  patch "/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,delete(conn,Handler,AuthHandler,Service,id))
  end
  
  patch "/unDrop/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,unDrop(conn,Handler,AuthHandler,Service,id))
  end
  
  patch "/trullyDrop/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,trullyDrop(conn,Handler,AuthHandler,Service,id))
  end 
  
  match _ do
    notFound(conn)
  end
  
end