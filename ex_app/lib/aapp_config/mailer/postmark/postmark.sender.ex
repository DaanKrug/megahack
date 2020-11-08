defmodule ExApp.PostMarkSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer
  
  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    credentials = %{server: "smtp.postmarkapp.com", 
  	                    username: mailConf.senderPassword, 
  	                    password: mailConf.senderPassword}
  	    GenericMail.getMail(mailConf,title,body,tto)
  	      |> GenericMail.putHeader("X-PM-Message-Stream","outbound")
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