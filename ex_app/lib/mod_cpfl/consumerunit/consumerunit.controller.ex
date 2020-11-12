defmodule ExApp.ConsumerunitController do
 
  import Plug.Conn
  use Plug.Router
  use ExApp.BasicController
  alias ExApp.NumberUtil
  alias ExApp.ConsumerunitHandler, as: Handler
  alias ExApp.ConsumerunitService, as: Service
  alias ExApp.AuthHandler, as: AuthHandler
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)
  
  post "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.registerFault(conn.params))
  end

  post "/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,Handler.registerFaultByConsumerUnitId(id))
  end
  
  post "/:page/:rows" do
    page = NumberUtil.toInteger(StringUtil.decodeUri("#{page}"))
    rows = NumberUtil.toInteger(StringUtil.decodeUri("#{rows}"))
    sendResponse(conn,loadAll(conn,Handler,Service,page,rows))
  end
  
  put "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.registerReBinding(conn.params))
  end

  put "/:id" do
    id = NumberUtil.toInteger(StringUtil.decodeUri("#{id}"))
    sendResponse(conn,Handler.registerReBindingByConsumerUnitId(id))
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