defmodule ExApp.TimeSyncService do

  use ExApp.BaseServiceSecure
  alias ExApp.Config.DAOService
  alias ExApp.DateUtil
  alias ExApp.MapUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.TimeSync
  
  def getRightTime(language) do
    lastDiff = loadByLanguage(language)
    cond do
      (nil == lastDiff) -> DateUtil.getDateTimeNowMillis()
      true -> DateUtil.getDateTimeNowMillis() + MapUtil.get(lastDiff,:systemdiff)
    end
  end
  
  def loadByLanguage(language) do
    sql = """
	      select id, language, systemdiff from timesync 
	      where language = ? order by id desc limit 1
	      """
	resultset = DAOService.load(sql,[language])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getTimeSync(resultset)
    end
  end
  
  def loadById(id) do
    sql = """
	      select id, language, systemdiff from timesync 
	      where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getTimeSync(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into timesync(language,systemdiff,created_at) values (?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update timesync set language = ?, systemdiff = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_timesync) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from timesync where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, language, systemdiff from timesync where #{deletedAt} #{conditions}
          order by id asc
           #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [TimeSync.new(0,nil,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [TimeSync.new(0,nil,0,0)]
  end
  
  def delete(id) do
    DAOService.update("update timesync set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update timesync set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from timesync where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getTimeSync(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getTimeSync(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    TimeSync.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
	             ResultSetHandler.getColumnValue(resultset,row,1),
                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,2)),
                 total)
  end
    
end

