defmodule ExApp.MailerConfigService do

  use ExApp.BaseServiceSecure
  alias ExApp.BillingControl.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.MapUtil
  alias ExApp.ResultSetHandler
  alias ExApp.MailerConfig
  alias ExApp.UserService
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from mailerconfig where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def userIsIn(userId) do
  	resultset = DAOService.load("select id from mailerconfig where userId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, provider, name, username, password, position, 
	      perMonth, perDay, perHour, perMinute, perSecond, replayTo,
          lastTimeUsed, userId, ownerId from mailerconfig where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getMailerConfig(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into mailerconfig(provider,name,username,password,position,perMonth,perDay,perHour,perMinute,
          perSecond,replayTo,userId,ownerId,created_at) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update mailerconfig set provider = ?, name = ?, username = ?, password = ?, position = ?, perMonth = ?,
          perDay = ?, perHour = ?, perMinute = ?, perSecond = ?, replayTo = ?, updated_at = ?
          where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_mailerconfig) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,mapParams) do
    ownerId = MapUtil.get(mapParams,:ownerId)
    user = UserService.loadById(ownerId)
    category = MapUtil.get(user,:category)
    conditions = cond do
      (category != "admin") -> conditions
      true -> " #{conditions} and ownerId = #{ownerId} " 
    end
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from mailerconfig where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, provider, name, username, password, position, 
          perMonth, perDay, perHour, perMinute, perSecond, replayTo,
          lastTimeUsed, userId, ownerId from mailerconfig where #{deletedAt} #{conditions} 
          order by position asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [MailerConfig.new(0,nil,nil,nil,nil,0,0,0,0,0,0,nil,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [MailerConfig.new(0,nil,nil,nil,nil,0,0,0,0,0,0,nil,nil,0,0,0)]
  end
  
  def delete(id) do
    DAOService.update("update mailerconfig set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update mailerconfig set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from mailerconfig where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getMailerConfig(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getMailerConfig(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    MailerConfig.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
	                 ResultSetHandler.getColumnValue(resultset,row,1),
		             ResultSetHandler.getColumnValue(resultset,row,2),
		             ResultSetHandler.getColumnValue(resultset,row,3),
	                 ResultSetHandler.getColumnValue(resultset,row,4),
    	             NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5)),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,7)),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,8)),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,9)),
	                 NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,10)),
     	             ResultSetHandler.getColumnValue(resultset,row,11),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,12)),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,13)),
			         NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,14)),
			         total)
  end
    
end

