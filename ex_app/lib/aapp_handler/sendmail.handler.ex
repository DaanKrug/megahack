defmodule ExApp.SendMailHandler do

  alias ExApp.NumberUtil
  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.SkallertenMailSender
  alias ExApp.GoogleMailSender
  alias ExApp.SendinBlueSender
  alias ExApp.MailjetSender
  alias ExApp.SparkPostSender
  alias ExApp.PostMarkSender
  alias ExApp.SendgridSender
  #alias ExApp.MandrillSender
  #alias ExApp.SendPulseSender
  alias ExApp.Smtp2goSender
  #alias ExApp.TurboSmtpSender
  alias ExApp.ElasticEmailSender
  alias ExApp.IagenteSender
  alias ExApp.SocketLabSender
  alias ExApp.BillingServiceApp

  def sendSimpleMail(mailConf,title,body,tto,ownerId) do 
    tto = tto |> String.downcase()
    provider = MapUtil.get(mailConf,:provider)
    body = appendFooterInfo(body,provider,MapUtil.get(mailConf,:replayTo))
    result = cond do
      (provider == "skallerten") -> SkallertenMailSender.mail(mailConf,title,body,tto)
      (provider == "gmail") -> GoogleMailSender.mail(mailConf,title,body,tto)
      (provider == "sendinblue") -> SendinBlueSender.mail(mailConf,title,body,tto)
      (provider == "mailjet") -> MailjetSender.mail(mailConf,title,body,tto)
      (provider == "sparkpost") -> SparkPostSender.mail(mailConf,title,body,tto)
      (provider == "sendgrid") -> SendgridSender.mail(mailConf,title,body,tto) # NOT SURE THAT'S OK FOR USE
      #(provider == "mandrill") -> MandrillSender.mail(mailConf,title,body,tto) # NOT OK FOR USE
      #(provider == "sendpulse") -> SendPulseSender.mail(mailConf,title,body,tto) # NOT OK FOR USE
      (provider == "smtp2go") -> Smtp2goSender.mail(mailConf,title,body,tto)
      #(provider == "turbosmtp") -> TurboSmtpSender.mail(mailConf,title,body,tto) # NOT OK FOR USE
      (provider == "elasticemail") -> ElasticEmailSender.mail(mailConf,title,body,tto)
      (provider == "iagente") -> IagenteSender.mail(mailConf,title,body,tto)
      (provider == "socketlab") -> SocketLabSender.mail(mailConf,title,body,tto)
      (provider == "postmark") -> PostMarkSender.mail(mailConf,title,body,tto)
      true -> 0
    end
    updateMailerUsage(result,mailConf,ownerId)
  end
  
  defp appendFooterInfo(body,provider,replayTo) do
    replayToMsg = cond do
      (nil == replayTo || StringUtil.trim(replayTo) == "") -> ""
      true -> """
              <div style="margin-top: 2em; border-top: 1px solid #ccc; border-bottom: 1px solid #ccc;">
                  Este email pode ser respondido para: 
                  <span style="color: #01f; font-weight: bold;">#{replayTo}</span>
              </div>
              """
    end
    """
    #{body} #{replayToMsg}
    <div style="color: #ada5a5; margin-top: .4em; border-top: 1px dashed #ada5a5;
                border-bottom: 1px dashed #ada5a5;">
    	Powered by: <strong>#{provider |> String.upcase()}</strong>
    </div>
    """
  end
  
  defp updateMailerUsage(result,mailConf,ownerId) do
    if(result == 1) do
      date = Date.utc_today()
      BillingServiceApp.createOrUpdateMailerUsage(NumberUtil.toInteger(MapUtil.get(mailConf,:id)),ownerId,
                                               date.day,date.month,date.year,1,MapUtil.get(mailConf,:provisioned))
    end
    result
  end
  
end