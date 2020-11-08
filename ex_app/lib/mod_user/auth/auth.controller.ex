defmodule ExApp.AuthController do
  
  import Plug.Conn
  use Plug.Router
  use ExApp.BaseController
  alias ExApp.StringUtil
  alias ExApp.GenericValidator
  alias ExApp.AuthHandler, as: Handler
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)

  put "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.login(conn.params,GenericValidator.getIp(conn.remote_ip)))
  end
  
  patch "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.logoff(conn.params))
  end
  
  match _ do
    notFound(conn)
  end
  
end