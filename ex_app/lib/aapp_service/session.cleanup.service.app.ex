defmodule ExApp.SessionCleanupServiceApp do

  alias ExApp.Session.DAOService
  alias ExApp.DateUtil
  
  def makeCleanup() do
    cleanupOldHistoryAccess()
    cleanupOldLoginTentatives()
    cleanupOldLoggedUsers()
  end
  
  # oldest than 2 minutes
  defp cleanupOldHistoryAccess() do
  	DAOService.delete("delete from accesscontrol where created_at < ?",[DateUtil.minusMinutesSql(2)])
  end
  
  # oldest than 10 minutes
  defp cleanupOldLoginTentatives() do
    sql = "delete from logintentatives where (created_at < ? and amount < 2) or (updated_at < ?)"
    timesql = DateUtil.minusMinutesSql(10)
  	DAOService.delete(sql,[timesql,timesql])
  end
  
  # oldest than 40 minutes
  defp cleanupOldLoggedUsers() do
  	DAOService.delete("delete from loggedusers where updated_at < ?",[DateUtil.minusMinutesSql(40)])
  end
  
end