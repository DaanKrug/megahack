defmodule ExApp.BillingServiceApp do

  alias ExApp.BillingControl.DAOService
  alias ExApp.ResultSetHandler
  alias ExApp.NumberUtil
  alias ExApp.DateUtil
  
  def createOrUpdateMailerUsage(mailerConfigId,userId,day,month,year,amount,provisioned) do
    now = DateUtil.getNowToSql(0,false,false)
    sql = """
          select id from mailerusage where mailerConfigId = ? and userId = ?
          and day = ? and month = ? and year = ? and date = ? and provisioned = ? limit 1
          """
    resultset = DAOService.load(sql,[mailerConfigId,userId,day,month,year,now,provisioned])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> 
      	createMailerUsage(mailerConfigId,userId,day,month,year,amount,now,provisioned)
      true -> updateMailerUsage(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0)),amount)
    end
  end
  
  defp createMailerUsage(mailerConfigId,userId,day,month,year,amount,date,provisioned) do
    sql = """
          insert into mailerusage(mailerConfigId,userId,day,month,year,amount,date,provisioned) values(?,?,?,?,?,?,?,?)
          """
    DAOService.insert(sql,[mailerConfigId,userId,day,month,year,amount,date,provisioned])
  end
  
  defp updateMailerUsage(id,amount) do
    DAOService.update("update mailerusage set amount = (amount + ?) where id = ?",[amount,id])
  end
  
end












