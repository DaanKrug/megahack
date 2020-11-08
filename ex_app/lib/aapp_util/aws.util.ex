defmodule ExApp.AWSUtil do

  def makeAwsRequest(object,configOverrides) do
  	ExAws.request(object,configOverrides) 
  	  |> getAwsRequestResult()
  end
  
  defp getAwsRequestResult({:ok, term}) do
    #IO.puts("SUCCESS: getAwsRequestResult")
    #IO.inspect(term)
    term
  end
  
  defp getAwsRequestResult({:error, _term}) do
    #IO.puts("ERROR: getAwsRequestResult")
    #IO.inspect(term)
    nil
  end
  
end