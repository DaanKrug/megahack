defmodule ExApp.UserServiceApp do

  alias ExApp.App.DAOService
  alias ExApp.ResultSetHandler
  alias ExApp.NumberUtil
  alias ExApp.StringUtil
  alias ExApp.User
  
  def loadIdByEmail(email) do
    resultset = DAOService.load("select id from user where email = ? limit 1",[email])
    NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
  end
  
  def loadForPermission(id) do
    sql = """
	      select id, name, email, category, permissions, active, ownerId from user where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getUserFiveColumns(resultset)
    end
  end
  
  def loadChildIds(id) do
    sql = "select GROUP_CONCAT(id) from user where ownerId = ?"
  	resultset = DAOService.load(sql,[id])
  	ids = cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> ResultSetHandler.getColumnValue(resultset,0,0)
    end
    cond do
      (nil == ids or StringUtil.trim(ids) == "") -> "0"
      true -> ids
    end
  end
  
  defp getUserFiveColumns(resultset,row \\ 0) do
    User.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
             ResultSetHandler.getColumnValue(resultset,row,1),
             ResultSetHandler.getColumnValue(resultset,row,2),
             nil,
             ResultSetHandler.getColumnValue(resultset,row,3),
             ResultSetHandler.getColumnValue(resultset,row,4),
             NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
             nil,
             NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
             0)
  end
  
end