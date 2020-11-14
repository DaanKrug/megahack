defmodule ExApp.AwsrekoginitionController do
 
  import Plug.Conn
  use Plug.Router
  use ExApp.BasicController
  alias ExApp.AwsrekoginitionHandler, as: Handler
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)
  
  post "/" do
    {:ok, _body, conn} = Plug.Conn.read_body(conn)
    sendResponse(conn,Handler.makeRekognition(conn.params))
  end

  match _ do
    notFound(conn)
  end
  
end