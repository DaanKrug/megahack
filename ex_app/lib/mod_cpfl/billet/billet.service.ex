defmodule ExApp.BilletService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Billet 
  
  
  def loadById(id) do
    sql = """
	      select id, a1_clientid,
          a2_consumerunitid,
          a3_value,
          a4_billingdate,
          active, ownerId from billet where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getBillet(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into billet(a1_clientid,
          a2_consumerunitid,
          a3_value,
          a4_billingdate,
          active,ownerId,created_at) values (?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update billet set
          a3_value = ?,
          a4_billingdate = ?,
          active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_billet) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from billet where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, a1_clientid,
          a2_consumerunitid,
          a3_value,
          a4_billingdate,
          active, 
          ownerId from billet 
          where #{deletedAt} #{conditions} 
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Billet.new(0,0,0,0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [Billet.new(0,0,0,0,nil,0,0,0)]
  end 
  
  def delete(id) do
    DAOService.update("update billet set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update billet set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from billet where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getBillet(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getBillet(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Billet.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,1)),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
               NumberUtil.toFloat(ResultSetHandler.getColumnValue(resultset,row,3)),
               ResultSetHandler.getColumnValue(resultset,row,4),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
               total)
  end
  
end