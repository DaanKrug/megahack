defmodule ExApp.MailerConfigUsedQuotaServiceTask do

  alias ExApp.BillingControl.DAOService
  alias ExApp.ResultSetHandler
  alias ExApp.NumberUtil
  alias ExApp.MapUtil
  
  def updateAtualUsage(ownerId,mailerConfigId,year,month,day,hour,minute,second,total) do
    sql = """
          select id from mailerconfigusedquota where ownerId = ? and mailerConfigId = ? and year = ? and month = ? 
          and day = ? and hour = ? and minute = ? and second = ?
          """
    resultset = DAOService.load(sql,[ownerId,mailerConfigId,year,month,day,hour,minute,second])
    cond do
      (nil != resultset && resultset.num_rows > 0) -> update(resultset,total)
      true -> create(mailerConfigId,year,month,day,hour,minute,second,total,ownerId)
    end
  end
  
  def loadAtualUsage(mailConf) do
    date = Date.utc_today()
    time = Time.utc_now()
    id = NumberUtil.toInteger(MapUtil.get(mailConf,:id))
    mailConf = Map.replace!(mailConf,:usedPerMonth,loadAtualUsageMonthly(id,date))
    mailConf = Map.replace!(mailConf,:usedPerDay,loadAtualUsageDaily(id,date))
    mailConf = Map.replace!(mailConf,:usedPerHour,loadAtualUsageHourly(id,date,time))
    mailConf = Map.replace!(mailConf,:usedPerMinute,loadAtualUsageMinutly(id,date,time))
    Map.replace!(mailConf,:usedPerSecond,loadAtualUsageSecondly(id,date,time))
  end
  
  defp update(resultset,total) do
    id = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    DAOService.update("update mailerconfigusedquota set amount = (amount + ?) where id = ?",[total,id])
  end
  
  defp create(mailerConfigId,year,month,day,hour,minute,second,total,ownerId) do
    sql = """
          insert into mailerconfigusedquota(mailerConfigId,year,month,day,hour,minute,second,amount,ownerId)
          values(?,?,?,?,?,?,?,?,?)
          """
    DAOService.insert(sql,[mailerConfigId,year,month,day,hour,minute,second,total,ownerId])
  end
  
  defp loadAtualUsageMonthly(id,date) do
    sql = """
          select sum(amount) as amount from mailerconfigusedquota where mailerConfigId = ?
          and year = ? and month = ?
          """
    resultset = DAOService.load(sql,[id,date.year,date.month])
    ResultSetHandler.getColumnValueAsInteger(resultset,0,0)
  end
  
  defp loadAtualUsageDaily(id,date) do
    sql = """
          select sum(amount) as amount from mailerconfigusedquota where mailerConfigId = ?
          and year = ? and month = ? and day = ?
          """
    resultset = DAOService.load(sql,[id,date.year,date.month,date.day])
    ResultSetHandler.getColumnValueAsInteger(resultset,0,0)
  end
  
  defp loadAtualUsageHourly(id,date,time) do
    sql = """
          select sum(amount) as amount from mailerconfigusedquota where mailerConfigId = ?
          and year = ? and month = ? and day = ? and hour = ?
          """
    resultset = DAOService.load(sql,[id,date.year,date.month,date.day,time.hour])
    ResultSetHandler.getColumnValueAsInteger(resultset,0,0)
  end
  
  defp loadAtualUsageMinutly(id,date,time) do
    sql = """
          select sum(amount) as amount from mailerconfigusedquota where mailerConfigId = ?
          and year = ? and month = ? and day = ? and hour = ? and minute = ?
          """
    resultset = DAOService.load(sql,[id,date.year,date.month,date.day,time.hour,time.minute])
    ResultSetHandler.getColumnValueAsInteger(resultset,0,0)
  end
  
  defp loadAtualUsageSecondly(id,date,time) do
    sql = """
          select sum(amount) as amount from mailerconfigusedquota where mailerConfigId = ?
          and year = ? and month = ? and day = ? and hour = ? and minute = ? and second = ?
          """
    resultset = DAOService.load(sql,[id,date.year,date.month,date.day,time.hour,time.minute,time.second])
    ResultSetHandler.getColumnValueAsInteger(resultset,0,0)
  end

end


