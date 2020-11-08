defmodule ExApp.ImageService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Image
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from image where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, link, description, forPublic, ownerId from image where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getImage(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into image(name,link,description,forPublic,ownerId,created_at) values (?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update image set name = ?, link = ?, description  = ?, forPublic = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_image) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from image where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, link, description, forPublic, ownerId from image where #{deletedAt} #{conditions}
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [Image.new(0,nil,nil,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from image where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, link, description, forPublic, 0 as ownerId from image where #{deletedAt} #{conditions}
          order by id asc
           #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [Image.new(0,nil,nil,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def delete(id) do
    DAOService.update("update image set deleted_at = ? where id = ?",[DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update image set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from image where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getImage(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getImage(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Image.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
		      ResultSetHandler.getColumnValue(resultset,row,1),
              ResultSetHandler.getColumnValue(resultset,row,2),
              ResultSetHandler.getColumnValue(resultset,row,3),
              NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,4)),
              NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
              total)
  end
    
end

