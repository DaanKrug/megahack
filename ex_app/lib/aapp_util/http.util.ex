defmodule ExApp.HttpUtil do

  def makeGetRequest(url,headers \\ [],debug \\ false) do
    HTTPoison.get(url,headers,[timeout: 2_000, recv_timeout: 2_000]) |> handleResponse(debug)
  end
  
  def makePostRequest(url,headers \\ [],debug \\ false) do
    HTTPoison.post(url,headers,[timeout: 2_000, recv_timeout: 2_000]) |> handleResponse(debug)
  end
  
  def handleResponse({:ok,response},_debug) do
  	response.body
  end
  
  def handleResponse({:error,reason},debug) do
    cond do
      (debug) -> reason
      true -> nil
    end
  end

end