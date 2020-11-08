defmodule ExApp.HttpService do

  def post(url,params,headers \\ [],options \\ []) do
	body = Poison.encode!(params)
	HTTPoison.post(url,body,headers,options) |> requestResult() 
  end
  
  def get(url,params,headers \\ [],options \\ []) do
	HTTPoison.get("#{url}?#{params}",headers,options) |> requestResult() 
  end
	
  defp requestResult({:ok, response}) do
  	IO.inspect(["response: ",response])
	response
  end
	
  defp requestResult({:error, reason}) do
	IO.inspect(["reason: ",reason])
	false
  end

end