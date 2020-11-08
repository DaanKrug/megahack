defmodule ExApp.TurboSmtpSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  # https://serversmtp.com/turbo-api/#send-email-2
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "https://api.turbo-smtp.com/api/mail/send", 
  	                    username: mailConf.senderEmail, 
  	                    password: mailConf.senderPassword}
  	    GenericMail.getMail(mailConf,title,body,tto)
          |> GenericSMTPMailer.deliverNow(credentials)
        1
  	  rescue
  	    _ -> 0
  	  end
  	catch
  	  _ -> 0
  	end
  end

end