defmodule ExApp.FileService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.MapUtil
  alias ExApp.ResultSetHandler
  alias ExApp.File
  alias ExApp.S3FileHandler
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from file where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, link, ownerId from file where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getFile(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into file(name,link,ownerId,created_at) values (?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update file set name = ?, link = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_file) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from file where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, link, ownerId from file where #{deletedAt} #{conditions}
          order by id asc
           #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [File.new(0,nil,nil,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [File.new(0,nil,nil,0,0)]
  end
  
  def delete(id) do
    DAOService.update("update file set deleted_at = ? where id = ?",[DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update file set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    file = loadById(id)
    cond do
      (nil == file or !(S3FileHandler.deleteFromS3(MapUtil.get(file,:link),MapUtil.get(file,:ownerId)))) -> false
      true -> DAOService.delete("delete from file where id = ?",[id])
    end
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getFile(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getFile(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    File.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
	         ResultSetHandler.getColumnValue(resultset,row,1),
             ResultSetHandler.getColumnValue(resultset,row,2),
             NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
             total)
  end
    
end

