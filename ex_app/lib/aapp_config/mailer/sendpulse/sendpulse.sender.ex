defmodule ExApp.SendPulseSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  # https://sendpulse.com/features/transactional
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "smtp-pulse.com", 
  	                    username: mailConf.senderEmail, 
  	                    password: mailConf.senderPassword, 
  	                    port: 2525}
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