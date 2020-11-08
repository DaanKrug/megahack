defmodule ExApp.SimpleMailServiceTask do

  alias ExApp.Queue.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.StringUtil
  alias ExApp.ResultSetHandler
  alias ExApp.QueuedMailServiceTask
  
  def updateStatus(id,newStatus) do
	sql = cond do
	  (newStatus == "startProcessing") -> """
	                                      update simplemail set status = ?, successAddress = "", failAddress = "",
	                                      failMessages = "", successTotal = 0, failTotal = 0 where id = ?
	                                      """
	  true -> "update simplemail set status = ? where id = ?"
	end
	DAOService.update(sql,[newStatus,id])
  end
  
  def loadNextToQueue() do
    sql = """
          select id, subject, content, tosAddress, ownerId from simplemail where status = ? order by id asc limit 1
	      """ 
	DAOService.load(sql,["awaiting"])     
  end
  
  def loadNextToQueueFailedResend() do
    sql = """
          select id, subject, content, failAddress, ownerId from simplemail where status = ? order by id asc limit 1
	      """ 
	DAOService.load(sql,["reSend"])     
  end
  
  def loadNextIdToDispatch(idsNotInString) do
    sql = """
          select id from simplemail where status = ? and id not in(#{idsNotInString}) order by id asc limit 1
	      """
	DAOService.load(sql,["processing"])     
  end
  
  def successfullySended(simpleMailId,tto) do
    sql = """
          select successAddress, successTotal, failTotal, tosTotal from simplemail where id = ?
	      """ 
	resultset = DAOService.load(sql,[simpleMailId])
	successAddress = ResultSetHandler.getColumnValue(resultset,0,0)
    successTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,1)) + 1
    failTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,2))
    tosTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,3))
    now = DateUtil.getNowToSql(0,false,false)
    sql = cond do
      (tosTotal > (successTotal + failTotal)) -> """
                                                 update simplemail set successAddress = ?, successTotal = ?, 
                                                 updated_at = ? where id = ?
                                                 """
      true -> """
              update simplemail set successAddress = ?, successTotal = ?, status = "finished", updated_at = ? where id = ?
              """
    end
    DAOService.update(sql,[Enum.join([successAddress,tto],","),successTotal,now,simpleMailId])
  end
  
  def failedToSend(simpleMailId,tto) do
    sql = """
          select failAddress, successTotal, failTotal, tosTotal from simplemail where id = ?
	      """ 
	resultset = DAOService.load(sql,[simpleMailId])
	failAddress = ResultSetHandler.getColumnValue(resultset,0,0)
    successTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,1))
    failTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,2)) + 1
    tosTotal = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,3))
    now = DateUtil.getNowToSql(0,false,false)
    sql = cond do
      (tosTotal > (successTotal + failTotal)) -> """
                                                 update simplemail set failAddress = ?, failTotal = ?, 
                                                 updated_at = ? where id = ?
                                                 """
      true -> """
              update simplemail set failAddress = ?, failTotal = ?, status = "finished", updated_at = ? where id = ?
              """
    end
    DAOService.update(sql,[Enum.join([failAddress,tto],","),failTotal,now,simpleMailId]) 
  end
  
  def failByConfigurationOutbound(simpleMailId,tto) do
	outBoundMsg = obtainLastMessages(simpleMailId,true,false)
	timeOutMsg = obtainLastMessages(simpleMailId,false,true)
	repeatedMessage = cond do
	  (outBoundMsg == "") -> ""
	  true -> """
	          <br/>Esta falha foi recorrente para este envio de e-mail, podendo ter ocorrido para mais de um dos destinatários.
	          Poderá gerar falhas no envio devido ao estouro de tempo limite. 
	          """
	end
	newMessage = Enum.join([
	  timeOutMsg,
	  messageSeparator(),
	  ~s(<div class="alert-warning justify" style="padding: 0;">),
	  "<strong>[",
	  DateUtil.getDateAndTimeNowString(),
	  "][outBoundMessage]</strong>",
	  " Falha ao enviar e-mail para: <strong>",
	  tto,
	  "</strong> por falta de capacidade de envio das configurações de e-mail. Nova tentativa de envio será realizada em breve.",
	  " Indica que deve-se adicionar mais capacidade/configurações de envio.",
	  repeatedMessage,
	  "</div>",
	  messageSeparator()
	],"")
    now = DateUtil.getNowToSql(0,false,false)
    DAOService.update("update simplemail set failMessages = ?, updated_at = ? where id = ?",[newMessage,now,simpleMailId])
  end
  
  def failByConfigurationTimeout(simpleMailId,mailId,tto) do
    resultset = DAOService.load("select failAddress, failTotal from simplemail where id = ?",[simpleMailId])
	failAddressOld = ResultSetHandler.getColumnValue(resultset,0,0)
	failTotalOld = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,1))
    resultset = QueuedMailServiceTask.failByConfigurationTimeout(simpleMailId,mailId)
    failAddressNew = ResultSetHandler.concatColsOfResultRows(resultset,0)
    failTotalNew = failTotalOld + (length(StringUtil.split(failAddressNew,",")))
    failAddressNew = StringUtil.concat(failAddressOld,failAddressNew,",")
    outBoundMsg = obtainLastMessages(simpleMailId,true,false)
	timeOutMsg = obtainLastMessages(simpleMailId,false,true)
	repeatedMessage = cond do
	  (timeOutMsg == "") -> ""
	  true -> """
	          <br/>Esta falha foi recorrente para este e-mail, podendo ter ocorrido para mais de um dos destinatários.
	          """
	end
	newMessage = Enum.join([
	  outBoundMsg,
	  messageSeparator(),
	  ~s(<div class="alert-warning justify" style="padding: 0;">),
	  "<strong>[",
	  DateUtil.getDateAndTimeNowString(),
	  "][timeOutMessage]</strong>",
	  " Falha ao enviar e-mail para: <strong>",
	  tto,
	  "</strong> por estouro de tempo limite da capacidade de envio das configurações de e-mail.",
	  " Indica que é necessário adicionar mais capacidade/configurações de envio para",
	  " evitar o estouro de tempo limite de envio da mensagem.",
	  repeatedMessage,
	  "</div>",
	  messageSeparator()
	],"")
    now = DateUtil.getNowToSql(0,false,false)
    sql = """
          update simplemail set failMessages = ?, failAddress = ?, failTotal = ?,
          status = "finished", updated_at = ? where id = ?
          """
    DAOService.update(sql,[newMessage,failAddressNew,failTotalNew,now,simpleMailId])
  end
  
  defp obtainLastMessages(simpleMailId,forConfigurationOutbound,forConfigurationTimeout) do
    resultset = DAOService.load("select failMessages from simplemail where id = ?",[simpleMailId])
	failMessages = ResultSetHandler.getColumnValue(resultset,0,0)
    failMessagesArray = StringUtil.split(failMessages,messageSeparator())
    cond do
      (forConfigurationOutbound && forConfigurationTimeout) -> [lastOutboundMsg(failMessagesArray,""),
                                                                lastTimeoutMsg(failMessagesArray,"")]
      (forConfigurationOutbound) -> lastOutboundMsg(failMessagesArray,"")
      (forConfigurationTimeout) -> lastTimeoutMsg(failMessagesArray,"")
      true -> []
    end
  end
  
  defp lastOutboundMsg(failMessagesArray,last) do
    cond do
      (length(failMessagesArray) == 0) -> last
      (String.contains?(hd(failMessagesArray),"outBoundMessage")) -> lastOutboundMsg(tl(failMessagesArray),hd(failMessagesArray))
      true -> lastOutboundMsg(tl(failMessagesArray),last)
    end
  end
  
  defp lastTimeoutMsg(failMessagesArray,last) do
    cond do
      (length(failMessagesArray) == 0) -> last
      (String.contains?(hd(failMessagesArray),"timeOutMessage")) -> lastTimeoutMsg(tl(failMessagesArray),hd(failMessagesArray))
      true -> lastTimeoutMsg(tl(failMessagesArray),last)
    end
  end

  defp messageSeparator() do
    ~s(<span style="display: none;">|x|</span>)
  end
    
end

