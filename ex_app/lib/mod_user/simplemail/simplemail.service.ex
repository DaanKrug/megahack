defmodule ExApp.SimpleMailService do

  use ExApp.BaseServiceSecure
  alias ExApp.Queue.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.StringUtil
  alias ExApp.ResultSetHandler
  alias ExApp.SimpleMail
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from simplemail where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, subject, content, tosAddress, successAddress, failAddress, status, tosTotal, successTotal, 
          failTotal, ownerId, updated_at from simplemail where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getSimpleMail(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into simplemail(subject,content,tosAddress,status,randomKey,ownerId,tosTotal,created_at) 
          values (?,?,?,?,?,?,?,?)
	      """
	tosAddress = Enum.at(paramValues,2)
	tosTotal = length(StringUtil.split(tosAddress,","))
    DAOService.insert(sql,paramValues ++ [tosTotal,DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update simplemail set subject = ?, content = ?, tosAddress = ?, status = ?, updated_at = ?
          where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_simplemail) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from simplemail where #{deletedAt} #{conditions} and ownerId > 0",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, subject, content, tosAddress, successAddress, failAddress, status, tosTotal, successTotal, 
          failTotal, ownerId, updated_at
          from simplemail where #{deletedAt} #{conditions} and ownerId > 0 
          order by id desc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [SimpleMail.new(0,nil,nil,nil,nil,nil,nil,0,0,0,0,nil,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [SimpleMail.new(0,nil,nil,nil,nil,nil,nil,0,0,0,0,nil,0)]
  end
  
  def delete(id) do
    DAOService.update("update simplemail set deleted_at = ? where id = ?",[DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update simplemail set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from simplemail where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getSimpleMail(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getSimpleMail(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    SimpleMail.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
			       ResultSetHandler.getColumnValue(resultset,row,1),
	               ResultSetHandler.getColumnValue(resultset,row,2),
	               ResultSetHandler.getColumnValue(resultset,row,3),
	               ResultSetHandler.getColumnValue(resultset,row,4),
	               ResultSetHandler.getColumnValue(resultset,row,5),
	               ResultSetHandler.getColumnValue(resultset,row,6),
	               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,7)),
	               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,8)),
	               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,9)),
	               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,10)),
	               String.slice(ResultSetHandler.getColumnValue(resultset,row,11),0..18),
	               total)
  end
    
end

