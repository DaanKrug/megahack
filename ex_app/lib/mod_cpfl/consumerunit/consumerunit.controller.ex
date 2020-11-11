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
  
  match _ do
    notFound(conn)
  end
  
end