defmodule ExApp.Queue.DAOService do

  alias ExApp.Queue.Repo, as: DB
  alias ExApp.StructUtil

  def load(sql,params \\[]) do
    StructUtil.getValueFromTuple(executeSql(sql,params,false))
  end
  
  def insert(sql,params \\[]) do
  	(false != executeSql(sql,params,true))
  end
  
  def update(sql,params \\[]) do
  	(false != executeSql(sql,params,true))
  end
  
  def delete(sql,params \\[]) do
  	(false != executeSql(sql,params,true))
  end
  
  defp executeSql(sql,params,raise) do
  	try do
  	  cond do
  	    (raise == true) -> Ecto.Adapters.SQL.query!(DB,sql,params)
  	    true -> Ecto.Adapters.SQL.query(DB,sql,params)
  	  end
  	rescue
  	  RuntimeError -> false
  	  ArgumentError -> false
  	  Protocol.UndefinedError -> false
  	end
  end
  
end














