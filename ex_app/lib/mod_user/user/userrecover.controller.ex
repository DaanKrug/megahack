defmodule ExApp.UserRecoverController do
  
  import Plug.Conn
  use Plug.Router
  use ExApp.BaseController
  alias ExApp.UserRecoverHandler, as: Handler
  alias ExApp.StringUtil
  alias ExApp.GenericValidator
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)
  
  put "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.recover(conn.params,GenericValidator.getIp(conn.remote_ip)))
  end
  
  match _ do
    sendResponse(conn,0)
  end
  
end