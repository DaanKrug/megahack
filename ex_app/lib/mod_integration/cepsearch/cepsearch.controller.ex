defmodule ExApp.CepSearchController do
 
  import Plug.Conn
  use Plug.Router
  use ExApp.BasicController
  alias ExApp.CepSearchHandler, as: Handler
  
  plug(Plug.Logger, log: :debug)
  plug(Plug.Parsers,parsers: [:json],pass: ["application/json"],json_decoder: Poison)
  plug(:match)
  plug(CORSPlug)
  plug(:dispatch)
  
  
  post "/:cep" do
    cep = StringUtil.decodeUri("#{cep}")
    sendResponse(conn,Handler.searchCep(cep))
  end

  match _ do
    notFound(conn)
  end
  
end