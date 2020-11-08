defmodule ExApp.GoogleMailSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "smtp.gmail.com", 
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