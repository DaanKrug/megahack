defmodule ExApp.CepSearchHandler do

  alias ExApp.HttpUtil
  
  def searchCep(cep) do
    HttpUtil.makeGetRequest("viacep.com.br/ws/#{cep}/json/")
  end
    
end