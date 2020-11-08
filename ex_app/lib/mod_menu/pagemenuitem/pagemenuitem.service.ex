defmodule ExApp.PageMenuItemService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.PageMenuItem
  
  def userIsOwner(userId) do
    sql = "select id from pagemenuitem where ownerId = ? limit 1"
  	resultset = DAOService.load(sql,[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def pageMenuIsIn(pageMenuId) do
    sql = "select id from pagemenuitem where pageMenuId = ? limit 1"
  	resultset = DAOService.load(sql,[pageMenuId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, content, position, active, pageMenuId, ownerId 
	      from pagemenuitem where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getPageMenuItem(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into pagemenuitem(name,content,position,active,
          pageMenuId,ownerId,created_at) 
          values (?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update pagemenuitem set name = ?, content = ?, position = ?, 
          active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_pagemenuitem) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from pagemenuitem where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, content, position, active,
          pageMenuId, ownerId 
          from pagemenuitem where #{deletedAt} #{conditions} 
          order by position asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenuItem.new(0,nil,nil,0,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from pagemenuitem where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, 
          name, 
          content, 
          position, 
          active,
          pageMenuId, 
          0 as ownerId 
          from pagemenuitem where #{deletedAt} #{conditions} 
          order by position asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenuItem.new(0,nil,nil,0,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def delete(id) do
    DAOService.update("update pagemenuitem set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update pagemenuitem set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from pagemenuitem where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getPageMenuItem(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getPageMenuItem(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    PageMenuItem.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
		             ResultSetHandler.getColumnValue(resultset,row,1),
	                 ResultSetHandler.getColumnValue(resultset,row,2),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,4)),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
	                 total)
  end
    
end