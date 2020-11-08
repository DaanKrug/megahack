defmodule ExApp.ModuleService do

  use ExApp.BaseServiceSecure
  alias ExApp.Config.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Module
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from module where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def moduleActive(moduleName) do
    sql = """
          select id from module where name = ? and active = true
          and (deleted_at is null or deleted_at = "0000-00-00 00:00:00")
          """
  	resultset = DAOService.load(sql,[moduleName])
  	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, active, ownerId from module where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getModule(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into module(name,active,ownerId,created_at) values (?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update module set name = ?, active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_module) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from module where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, active, ownerId from module where #{deletedAt} #{conditions}
          order by name asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [Module.new(0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from module where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select 0 as id, name, active, 0 as ownerId from module where #{deletedAt} #{conditions}
           #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [Module.new(0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def delete(id) do
    DAOService.update("update module set deleted_at = ? where id = ?",[DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update module set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from module where id = ?",[id])
  end
  
  def alreadyExists(id,name,deletedAt) do
    sql = "select id from module where #{deletedAt} and id <> ? and name = ?"
    resultset = DAOService.load(sql,[id,name])
    (nil != resultset and resultset.num_rows > 0)
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getModule(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getModule(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Module.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
		       ResultSetHandler.getColumnValue(resultset,row,1),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
               total)
  end
    
end

