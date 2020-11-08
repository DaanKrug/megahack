defmodule ExApp.ElasticEmailSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  # https://elasticemail.com/email-api
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "smtp.elasticemail.com", 
  	                    username: mailConf.senderEmail, 
  	                    password: mailConf.senderPassword, port: 2525}
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