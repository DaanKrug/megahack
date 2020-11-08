defmodule ExApp.SendgridSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  # https://sendgrid.com/solutions/smtp-service/
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "smtp.sendgrid.com", 
  	                    username: "apikey", 
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