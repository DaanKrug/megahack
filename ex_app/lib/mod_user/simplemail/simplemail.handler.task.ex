defmodule ExApp.SimpleMailHandlerTask do

  alias ExApp.ResultSetHandler
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.DateUtil
  alias ExApp.QueuedMailServiceTask
  alias ExApp.SimpleMailServiceTask
  alias ExApp.SendMailHandler
  alias ExApp.MailerConfigServiceTask
  alias ExApp.MailerConfigUtil
  
  def loadConfigsForMailing() do
    MailerConfigServiceTask.loadConfigsForMailing()
  end
  
  def updateConfigsAfterMailed(configs) do
    if(nil != configs and length(configs) > 0) do
      MailerConfigServiceTask.updateConfigsAfterMailed(configs)
    end
  end
  
  def createQueuedMails() do
    resultset = SimpleMailServiceTask.loadNextToQueue()
    if(nil != resultset && resultset.num_rows > 0) do
      try do
        t1 = DateUtil.getDateTimeNowMillis()
        id = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
        SimpleMailServiceTask.updateStatus(id,"startProcessing")
        subject = ResultSetHandler.getColumnValue(resultset,0,1)
        content = ResultSetHandler.getColumnValue(resultset,0,2)
        tosAddress = ResultSetHandler.getColumnValue(resultset,0,3)
        ownerId = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,4))
        priority = cond do
          (ownerId == 0) -> 0
          true -> 1
        end
        QueuedMailServiceTask.create(priority,subject,content,StringUtil.split(tosAddress,","),id,
                                     ownerId,DateUtil.getDateTimeNowMillis())
        SimpleMailServiceTask.updateStatus(id,"processing")
        t2 = DateUtil.getDateTimeNowMillis()
        diff = t2 - t1
        sleepTime = cond do
	        (diff > 20000) -> 10000
	        (diff > 10000) -> 7000
	        (diff > 5000) -> 3000
	        (diff > 4000) -> 2000
	        (diff > 3000) -> 1000
	        (diff > 2000) -> 700
	        (diff > 1000) -> 500
	        true -> 300
	    end
        #IO.puts("createQueuedMails() duration: #{diff}ms going sleep for #{sleepTime}ms")
        :timer.sleep(sleepTime)
        createQueuedMails()
      rescue
        _ -> IO.puts("Error on ExApp.SimpleMailHandler.createQueuedMails(). Stopping.")
      end
    end
  end
  
  def markToResendFailedQueuedMails() do
    resultset = SimpleMailServiceTask.loadNextToQueueFailedResend()
    if(nil != resultset && resultset.num_rows > 0) do
      try do
        t1 = DateUtil.getDateTimeNowMillis()
        id = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
        SimpleMailServiceTask.updateStatus(id,"startProcessing")
        subject = ResultSetHandler.getColumnValue(resultset,0,1)
        content = ResultSetHandler.getColumnValue(resultset,0,2)
        failAddress = ResultSetHandler.getColumnValue(resultset,0,3)
        ownerId = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,4))
        QueuedMailServiceTask.create(1,subject,content,StringUtil.split(failAddress,","),id,ownerId,
                                     DateUtil.getDateTimeNowMillis())
        SimpleMailServiceTask.updateStatus(id,"processing")
        t2 = DateUtil.getDateTimeNowMillis()
        #IO.puts("markToResendFailedQueuedMails() duration: #{(t2 - t1)}ms going sleep for #{(t2 - t1)}ms")
        :timer.sleep(t2 - t1)
        markToResendFailedQueuedMails()
      rescue
        _ -> IO.puts("Error on ExApp.SimpleMailHandler.markToResendFailedQueuedMails(). Stopping.")
      end
    end
  end
  
  def dispatchQueuedMailsPriorityZero(configs) do
    resultset = cond do
      (nil == configs or length(configs) == 0) -> nil
      true -> QueuedMailServiceTask.loadNextPriorityZero()
    end
    cond do
      (nil == resultset or resultset.num_rows == 0) -> configs
      true -> handleDispatchQueuedMails(configs,"",resultset,0,true)
    end
  end
  
  def dispatchQueuedMailsPriorityNonZero(configs,idsNotInStringSimpleMail) do
    nextSimpleMailId = cond do
      (nil == configs or length(configs) == 0) -> 0
      true -> loadNextIdToDispatch(idsNotInStringSimpleMail)
    end
    cond do
      (!(nextSimpleMailId > 0)) -> configs
      true -> dispatchQueuedMailsPriorityNonZeroNextSimpleMailId(configs,idsNotInStringSimpleMail,nextSimpleMailId)
    end
  end
  
  defp loadNextIdToDispatch(idsNotInStringSimpleMail) do
    resultset = SimpleMailServiceTask.loadNextIdToDispatch(idsNotInStringSimpleMail)
    cond do
      (nil != resultset && resultset.num_rows > 0) 
        -> NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
      true -> 0
    end
  end
  
  defp dispatchQueuedMailsPriorityNonZeroNextSimpleMailId(configs,idsNotInStringSimpleMail,nextSimpleMailId) do
    idsNotInStringSimpleMail = StringUtil.concat(idsNotInStringSimpleMail,nextSimpleMailId,",")
    resultset = QueuedMailServiceTask.loadNextPriorityNonZero(nextSimpleMailId)
    handleDispatchQueuedMails(configs,idsNotInStringSimpleMail,resultset,0,false)
  end
  
  defp handleDispatchQueuedMails(configs,idsNotInStringSimpleMail,resultset,row,priorityZero) do
    cond do
      (nil != resultset and row < resultset.num_rows) 
        -> dispatchEmails(resultset,row,idsNotInStringSimpleMail,configs,priorityZero)
      (priorityZero == true) -> configs
      true -> dispatchQueuedMailsPriorityNonZero(configs,idsNotInStringSimpleMail)
    end
  end
  
  defp dispatchEmails(resultset,row,idsNotInStringSimpleMail,configs,priorityZero) do
    result = tryDispatchOneEmail(resultset,row,configs)
    usedPositionToSend = hd(tl(result))
    configs = MailerConfigUtil.markMailConfAsUsed(configs,usedPositionToSend)
    cond do
      (usedPositionToSend <= -2) 
        -> handleDispatchQueuedMails(configs,idsNotInStringSimpleMail,
                                     resultset,resultset.num_rows + 1,priorityZero)
      true -> handleDispatchQueuedMails(configs,idsNotInStringSimpleMail,resultset,row + 1,priorityZero)
    end
  end
  
  defp tryDispatchOneEmail(resultset,row,configs) do
    id = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0))
    messageTitle = ResultSetHandler.getColumnValue(resultset,row,1)
    messageBody = ResultSetHandler.getColumnValue(resultset,row,2)
    tto = ResultSetHandler.getColumnValue(resultset,row,3)
    simpleMailId = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,4))
    times = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,5))
    maxtimes = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6))
    ownerId = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,7))
    createdAt = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,8))
    usedPositionToSend = trySendMailOnAllConfigsProvisioned(configs,messageTitle,messageBody,
                                                            tto,ownerId,createdAt,0,0)
    usedPositionToSend = cond do
      !(usedPositionToSend == -2 and (times >= (maxtimes - 2))) -> usedPositionToSend
      true -> trySendMailOnAllConfigsNotProvisioned(configs,messageTitle,messageBody,
                                                    tto,ownerId,createdAt,0,0)
    end
    cond do
      (usedPositionToSend >= 0) -> successfullySended(simpleMailId,tto,id)
      (usedPositionToSend == -1 && ((times + 1) >= maxtimes)) -> failedToSend(simpleMailId,tto,id)
      (usedPositionToSend == -1) -> QueuedMailServiceTask.incrementTried(id,times)
      (usedPositionToSend == -2) -> outboundedSended(id,times,maxtimes,simpleMailId,tto)
      true -> SimpleMailServiceTask.failByConfigurationTimeout(simpleMailId,id,tto)
    end
    [id,usedPositionToSend]
  end
  
  defp outboundedSended(id,times,maxtimes,simpleMailId,tto) do
    if(times < (maxtimes - 2)) do
      QueuedMailServiceTask.incrementTried(id,times)
    end
    SimpleMailServiceTask.failByConfigurationOutbound(simpleMailId,tto)
  end
  
  defp successfullySended(simpleMailId,tto,id) do
    SimpleMailServiceTask.successfullySended(simpleMailId,tto)
    QueuedMailServiceTask.deleteById(id)
  end
  
  defp failedToSend(simpleMailId,tto,id) do
    SimpleMailServiceTask.failedToSend(simpleMailId,tto)
    QueuedMailServiceTask.deleteById(id)
  end
  
  defp trySendMailOnAllConfigsProvisioned(configs,title,body,tto,ownerId,createdAt,position,fails) do
    nowMillis = DateUtil.getDateTimeNowMillis()
    hourMillis = DateUtil.getHourMillis()
    cond do
      ((nil == configs || length(configs) == 0) && fails > 0) -> -1            #fail
      (nil == configs || length(configs) == 0) -> -2                           #no more configs
      (NumberUtil.toPositive(createdAt - nowMillis) > (3 * hourMillis)) -> -3  #timeout of 3 hours
      (!MailerConfigUtil.mailConfCanBeUsed(hd(configs),ownerId,true)) 
        -> trySendMailOnAllConfigsProvisioned(tl(configs),title,body,tto,ownerId,createdAt,position + 1,fails)
      (SendMailHandler.sendSimpleMail(hd(configs),title,body,tto,ownerId) == 1) -> position
      true -> trySendMailOnAllConfigsProvisioned(tl(configs),title,body,tto,ownerId,createdAt,position + 1,fails + 1)
    end 
  end
  
  defp trySendMailOnAllConfigsNotProvisioned(configs,title,body,tto,ownerId,createdAt,position,fails) do
    nowMillis = DateUtil.getDateTimeNowMillis()
    hourMillis = DateUtil.getHourMillis()
    cond do
      ((nil == configs || length(configs) == 0) && fails > 0) -> -1            #fail
      (nil == configs || length(configs) == 0) -> -2                           #no more configs
      (NumberUtil.toPositive(createdAt - nowMillis) > (3 * hourMillis)) -> -3  #timeout of 3 hours
      (!MailerConfigUtil.mailConfCanBeUsed(hd(configs),ownerId,false)) 
        -> trySendMailOnAllConfigsNotProvisioned(tl(configs),title,body,tto,ownerId,createdAt,position + 1,fails)
      (SendMailHandler.sendSimpleMail(hd(configs),title,body,tto,ownerId) == 1) -> position
      true -> trySendMailOnAllConfigsNotProvisioned(tl(configs),title,body,tto,ownerId,createdAt,position + 1,fails + 1)
    end 
  end

end
