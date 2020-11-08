defmodule ExApp.Smtp2goSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  # https://www.smtp2go.com/setup/
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "mail.smtp2go.com", 
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