defmodule ExApp.SocketLabSender do
  
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer
  alias ExApp.StringUtil

  def mail(mailConf,title,body,tto) do
    try do
  	  try do
  	    arr = mailConf.senderPassword |> StringUtil.split(",")
        credentials = %{server: "smtp.socketlabs.com", 
  	                    username: Enum.at(arr,0), 
  	                    password: Enum.at(arr,1)}
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