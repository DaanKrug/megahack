defmodule ExApp.SkallertenMailSender do
  
  alias ExApp.StringUtil
  alias ExApp.GenericMail
  alias ExApp.GenericSMTPMailer

  def mail(mailConf,title,body,tto) do
  	cond do
  	  (!addressCanBeReached(tto)) -> 0
  	  true -> sendMail(mailConf,title,body,tto)
  	end
  end
  
  defp sendMail(mailConf,title,body,tto) do
  	try do
	  try do
	  	credentials = %{server: "mail.skallerten.com.br", 
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
  
  defp addressCanBeReached(tto) do
    provider = tto |> StringUtil.split("@") |> Enum.at(1)
  	!(Enum.member?(notRecheableDomains(),provider))
  end
  
  defp notRecheableDomains() do
  	["hotmail.com","mail.com","outlook.com","outlook.com.br",
  	 "outlook.fr","outlook.de",
  	 "live.com","msn.com",
  	 "gmx.com","gmx.de","twcmail.de","web.de",
  	 "ufpr.br","furb.br","icloud.com"]
  end

end
