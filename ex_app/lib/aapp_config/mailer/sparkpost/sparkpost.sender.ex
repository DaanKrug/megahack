defmodule ExApp.SparkPostSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  def mail(mailConf,title,body,tto) do
    try do 
  	  try do
  	    credentials = %{server: "smtp.sparkpostmail.com", 
  	                    username: "SMTP_Injection", 
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