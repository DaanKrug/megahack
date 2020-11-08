defmodule ExApp.PageMenuService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.PageMenu
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from pagemenu where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, position, active, ownerId from pagemenu where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getPageMenu(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into pagemenu(name,position,active,ownerId,created_at) values (?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update pagemenu set name = ?, position = ?, active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_pagemenu) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from pagemenu where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, 
          name, 
          position, 
          active, 
          ownerId from pagemenu where #{deletedAt} #{conditions} 
          order by position asc, name asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenu.new(0,nil,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from pagemenu where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, 
          name, 
          position, 
          active, 
          0 as ownerId 
          from pagemenu where #{deletedAt} #{conditions} 
          order by position asc, name asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenu.new(0,nil,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def delete(id) do
    DAOService.update("update pagemenu set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update pagemenu set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from pagemenu where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getPageMenu(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getPageMenu(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    PageMenu.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
	             ResultSetHandler.getColumnValue(resultset,row,1),
                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,4)),
                 total)
  end
    
end

