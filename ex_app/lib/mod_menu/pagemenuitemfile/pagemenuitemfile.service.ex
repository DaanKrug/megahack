defmodule ExApp.PageMenuItemFileService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.PageMenuItemFile
  
  def userIsOwner(userId) do
    sql = "select id from pagemenuitemfile where ownerId = ? limit 1"
  	resultset = DAOService.load(sql,[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def pageMenuItemIsIn(pageMenuItemId) do
    sql = "select id from pagemenuitemfile where pageMenuItemId = ? limit 1"
  	resultset = DAOService.load(sql,[pageMenuItemId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def fileIsIn(fileId) do
    sql = "select id from pagemenuitemfile where fileId = ? limit 1"
  	resultset = DAOService.load(sql,[fileId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def updateByFile(fileId,fileLink) do
    sql = "update pagemenuitemfile set fileLink = ? where fileId = ?"
    DAOService.update(sql,[fileLink,fileId])
  end
  
  def loadById(id) do
    sql = """
	      select id, name, position, fileId, fileLink, pageMenuItemId, 
	      ownerId from pagemenuitemfile where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getPageMenuItemFile(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into pagemenuitemfile(name,position,fileId,fileLink,
          pageMenuItemId,ownerId,created_at) values (?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update pagemenuitemfile set name = ?, position = ?, updated_at = ? where id = ?
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
    sql = "select count(id) from pagemenuitemfile where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, position, fileId, fileLink, pageMenuItemId, ownerId
          from pagemenuitemfile where #{deletedAt} #{conditions}
          order by position asc, name asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenuItemFile.new(0,nil,0,0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from pagemenuitemfile where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, 
          name, 
          position, 
          fileId, 
          fileLink, 
          pageMenuItemId, 
          0 as ownerId
          from pagemenuitemfile where #{deletedAt} #{conditions}
          order by position asc, name asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [PageMenuItemFile.new(0,nil,0,0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def delete(id) do
    DAOService.update("update pagemenuitemfile set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update pagemenuitemfile set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from pagemenuitemfile where id = ?",[id])
  end
  
  def alreadyExists(id,pageMenuItemId,fileId,deletedAt) do
    sql = """
          select id from pagemenuitemfile where #{deletedAt} and id <> ? 
          and pageMenuItemId = ? and fileId = ?
          """
    resultset = DAOService.load(sql,[id,pageMenuItemId,fileId])
    (nil != resultset && resultset.num_rows > 0)
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getPageMenuItemFile(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getPageMenuItemFile(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    PageMenuItemFile.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
			             ResultSetHandler.getColumnValue(resultset,row,1),
		                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
		                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
		                 ResultSetHandler.getColumnValue(resultset,row,4),
		                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
		                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
		                 total)
  end
    
end

