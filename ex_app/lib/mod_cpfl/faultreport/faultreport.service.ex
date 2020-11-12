defmodule ExApp.FaultreportService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Faultreport 
  
  
  def hasRecentOthers(consumerUnitIds) do
    date = (DateUtil.getDateTimeNowMillis() - 3600000) |> DateUtil.timeToSqlDate()
    sql = """
	      select id from faultreport 
	      where a2_consumerunitid in(#{consumerUnitIds})
	      and created_at >= '#{date}'
	      limit 1
	      """
	resultset = DAOService.load(sql,[])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def hasRecent(clientId,consumerUnitId) do
    date = (DateUtil.getDateTimeNowMillis() - 300000) |> DateUtil.timeToSqlDate()
    sql = """
	      select id from faultreport where a1_clientid = ? 
	      and a2_consumerunitid = ?
	      and created_at >= '#{date}'
	      limit 1
	      """
	resultset = DAOService.load(sql,[clientId,consumerUnitId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadLast(clientId,consumerUnitId) do
    sql = """
	      select id, a1_clientid,
          a2_consumerunitid, 
          ownerId 
          from faultreport 
          where a1_clientid = ? and a2_consumerunitid = ? 
          order by id desc limit 1
	      """
	resultset = DAOService.load(sql,[clientId,consumerUnitId])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getFaultreport(resultset)
    end
  end
  
  def loadById(id) do
    sql = """
	      select id, a1_clientid,
          a2_consumerunitid, ownerId from faultreport where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getFaultreport(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into faultreport(a1_clientid,
          a2_consumerunitid,ownerId,created_at) values (?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update faultreport set a1_clientid = ?,
          a2_consumerunitid = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_faultreport) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from faultreport where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, a1_clientid,
          a2_consumerunitid, 
          ownerId from faultreport 
          where #{deletedAt} #{conditions} 
          order by id desc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Faultreport.new(0,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [Faultreport.new(0,0,0,0,0)]
  end 
  
  def delete(id) do
    DAOService.update("update faultreport set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update faultreport set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from faultreport where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getFaultreport(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getFaultreport(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Faultreport.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
                    NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,1)),
                    NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
                    NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,3)),
                    total)
  end
  
end