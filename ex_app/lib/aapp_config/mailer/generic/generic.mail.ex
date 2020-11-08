defmodule ExApp.GenericMail do

  import Bamboo.Email

  def getMail(mailConf,title,body,tto) do
    new_email(to: tto,from: {mailConf.senderName,mailConf.senderEmail},subject: title,html_body: body)
      |> put_header("Reply-To",mailConf.replayTo)
  end
  
  def putHeader(email,key,value) do
    put_header(email,key,value)
  end

end