defmodule ExApp.QueuedMailServiceTask do

  alias ExApp.Queue.DAOService
  alias ExApp.StringUtil
  
  def create(priority,messageTitle,messageBody,tos,simpleMailId,ownerId,createdAt) do
    cond do
      (nil == tos || length(tos) == 0) -> 1
      true -> insert(priority,messageTitle,messageBody,tos,simpleMailId,ownerId,createdAt)
    end
  end
  
  defp insert(priority,messageTitle,messageBody,tos,simpleMailId,ownerId,createdAt) do
    sql = """
          insert into queuedmail(priority,messageTitle,messageBody,tto,simpleMailId,times,maxtimes,lastTimeTried,
          ownerId,createdAt) values(?,?,?,?,?,?,?,?,?,?)
          """
    DAOService.insert(sql,[priority,messageTitle,messageBody,StringUtil.trim(hd(tos)),simpleMailId,0,4,0,ownerId,createdAt])
    create(priority,messageTitle,messageBody,tl(tos),simpleMailId,ownerId,createdAt)
  end
  
  def loadNextPriorityZero() do
    sql = """
          select id, messageTitle, messageBody, tto, simpleMailId, times, maxtimes, ownerId, createdAt from queuedmail 
          where priority = 0 and (
          (times = 0) or (times = 1 and lastTimeTried < ?) 
          or (times = 2 and lastTimeTried < ?) or (times >= 3 and lastTimeTried < ?)
          ) order by id asc, times desc, lastTimeTried asc limit 100
          """
    now = System.os_time()
    DAOService.load(sql,[now - 120000000,now - 300000000,now - 540000000]) 
    #02, 05, and 09 minutes ago respectively
  end
  
  def loadNextPriorityNonZero(simpleMailId) do
    sql = """
          select id, messageTitle, messageBody, tto, simpleMailId, times, maxtimes, ownerId, createdAt from queuedmail 
          where priority > 0 and simpleMailId = ? and (
          (times = 0) or (times = 1 and lastTimeTried < ?) 
          or (times = 2 and lastTimeTried < ?) or (times >= 3 and lastTimeTried < ?)
          ) order by id asc, times desc, lastTimeTried asc limit 10
          """
    now = System.os_time() 
  	DAOService.load(sql,[simpleMailId,now -  300000000,now - 1800000000,now - 7200000000]) 
  	#05 minutes, 30 minutes, and 02 hours ago respectively
  end
  
  def failByConfigurationTimeout(simpleMailId,id) do
    resultset = DAOService.load("select tto from queuedmail where simpleMailId = ? and id >= ?",[simpleMailId,id])
    DAOService.delete("delete from queuedmail where simpleMailId = ? and id >= ?",[simpleMailId,id])
    resultset
  end
  
  def incrementTried(id,times) do
    DAOService.update("update queuedmail set times = ?, lastTimeTried = ? where id = ?",[times + 1,System.os_time(),id])
  end
  
  def deleteById(id) do
    DAOService.delete("delete from queuedmail where id = ?",[id])
  end

end

