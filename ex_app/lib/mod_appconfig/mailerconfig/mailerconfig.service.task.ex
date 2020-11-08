defmodule ExApp.MailerConfigServiceTask do

  alias ExApp.BillingControl.DAOService
  alias ExApp.UserService
  alias ExApp.MailerConfigUsedQuotaServiceTask
  alias ExApp.ResultSetHandler
  alias ExApp.NumberUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.MapUtil
  
  def loadConfigsForMailing() do
    sql = """
          select id, provider, name, username, password, position, perMonth, perDay, 
          perHour, perMinute, perSecond, lastTimeUsed, replayTo, userId,
          ownerId from mailerconfig where #{AuthorizerUtil.getDeletedAt(nil,nil)}
          order by position asc
          """
    mapConfigs(DAOService.load(sql,[]),0,[])
  end
  
  def updateConfigsAfterMailed(mapConfigs) do
    cond do
      (nil == mapConfigs or length(mapConfigs) == 0) -> 1
      true -> updateConfigsByRunUsage(mapConfigs)
    end
  end
  
  defp setLastTimeUsed(mailerConfigId) do
    DAOService.update("update mailerconfig set lastTimeUsed = ? where id = ?",[System.os_time(),mailerConfigId])
  end
  
  defp updateConfigsByRunUsage(mapConfigs) do
    mailConf = hd(mapConfigs)
    ownerId = NumberUtil.toInteger(MapUtil.get(mailConf,:ownerId))
    mailerConfigId = NumberUtil.toInteger(MapUtil.get(mailConf,:id))
    runUsageArray = MapUtil.get(mailConf,:runUsage)
    updateConfigsByRunUsageArray(ownerId,mailerConfigId,runUsageArray)
    setLastTimeUsed(mailerConfigId)
    updateConfigsAfterMailed(tl(mapConfigs))
  end
  
  defp updateConfigsByRunUsageArray(ownerId,mailerConfigId,runUsageArray) do
    if(nil != runUsageArray && length(runUsageArray) > 0) do
      runUsage = hd(runUsageArray)
      year = NumberUtil.toInteger(MapUtil.get(runUsage,:year))
      month = NumberUtil.toInteger(MapUtil.get(runUsage,:month))
      day = NumberUtil.toInteger(MapUtil.get(runUsage,:day))
      hour = NumberUtil.toInteger(MapUtil.get(runUsage,:hour))
      minute = NumberUtil.toInteger(MapUtil.get(runUsage,:minute))
      second = NumberUtil.toInteger(MapUtil.get(runUsage,:second))
      total = NumberUtil.toInteger(MapUtil.get(runUsage,:total))
      MailerConfigUsedQuotaServiceTask.updateAtualUsage(ownerId,mailerConfigId,year,month,day,
                                                        hour,minute,second,total)
      updateConfigsByRunUsageArray(ownerId,mailerConfigId,tl(runUsageArray))
    end
  end
  
  defp mapConfigs(resultset,row,array) do
    cond do
      (nil == resultset or row >= resultset.num_rows) -> array
      true -> mapConfigOfResultset(resultset,row,array)
    end
  end
  
  defp mapConfigOfResultset(resultset,row,array) do
    ownerIdConfig = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,14))
    isProvisioned = !(UserService.isAdminMaster(ownerIdConfig))
    mailConf = %{
      id: ResultSetHandler.getColumnValue(resultset,row,0),
      provider: ResultSetHandler.getColumnValue(resultset,row,1),
      senderName:  ResultSetHandler.getColumnValue(resultset,row,2),
      senderEmail: ResultSetHandler.getColumnValue(resultset,row,3),
      senderPassword: ResultSetHandler.getColumnValue(resultset,row,4),
      perMonth: ResultSetHandler.getColumnValue(resultset,row,6),
      perDay: ResultSetHandler.getColumnValue(resultset,row,7),
      perHour: ResultSetHandler.getColumnValue(resultset,row,8),
      perMinute: ResultSetHandler.getColumnValue(resultset,row,9),
      perSecond: ResultSetHandler.getColumnValue(resultset,row,10),
      lastTimeUsed: ResultSetHandler.getColumnValue(resultset,row,11),
      replayTo: ResultSetHandler.getColumnValue(resultset,row,12),
      userId: ResultSetHandler.getColumnValue(resultset,row,13),
      ownerId: ownerIdConfig,
      provisioned: isProvisioned,
      usedPerMonth: 0,
      usedPerDay: 0,
      usedPerHour: 0,
      usedPerMinute: 0,
      usedPerSecond: 0,
      runUsage: []
    }
    mailConf = MailerConfigUsedQuotaServiceTask.loadAtualUsage(mailConf)
    validated = validateInitialUsage(mailConf)
    cond do
      (validated == true) -> mapConfigs(resultset,row + 1,[mailConf | array])
      true -> mapConfigs(resultset,row + 1,array)
    end
  end
  
  defp validateInitialUsage(mailConf) do
    cond do
      (MapUtil.get(mailConf,:usedPerMonth) >= MapUtil.get(mailConf,:perMonth)) -> false
      (MapUtil.get(mailConf,:usedPerDay) >= MapUtil.get(mailConf,:perDay)) -> false
      (MapUtil.get(mailConf,:usedPerHour) >= MapUtil.get(mailConf,:perHour)) -> false
      (MapUtil.get(mailConf,:usedPerMinute) >= MapUtil.get(mailConf,:perMinute)) -> false
      true -> true
    end
  end
  
end
