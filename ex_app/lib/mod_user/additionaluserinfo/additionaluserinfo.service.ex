defmodule ExApp.AdditionaluserinfoService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Additionaluserinfo
  
  def loadById(id) do
    sql = """
	      select id, a1_rg,
          a2_cpf,
          a3_cns,
          a4_phone,
          a5_address,
          a6_otherinfo,
          a7_userid, ownerId from additionaluserinfo where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getAdditionaluserinfo(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into additionaluserinfo(a1_rg,
          a2_cpf,
          a3_cns,
          a4_phone,
          a5_address,
          a6_otherinfo,
          a7_userid,ownerId,created_at) values (?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update additionaluserinfo set a1_rg = ?,
          a2_cpf = ?,
          a3_cns = ?,
          a4_phone = ?,
          a5_address = ?,
          a6_otherinfo = ?,
          updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_additionaluserinfo) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from additionaluserinfo where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, a1_rg,
          a2_cpf,
          a3_cns,
          a4_phone,
          a5_address,
          a6_otherinfo,
          a7_userid, 
          ownerId from additionaluserinfo 
          where #{deletedAt} #{conditions} 
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Additionaluserinfo.new(0,nil,nil,nil,nil,nil,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def deleteByUserId(userId) do
    DAOService.update("update additionaluserinfo set deleted_at = ? where a7_userid = ?",
                      [DateUtil.getNowToSql(0,false,false),userId])
  end
  
  def unDropByUserId(userId) do
    DAOService.update("update additionaluserinfo set deleted_at = null where a7_userid = ?",[userId])
  end
  
  def trullyDropByUserId(userId) do
    DAOService.delete("delete from additionaluserinfo where a7_userid = ?",[userId])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getAdditionaluserinfo(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getAdditionaluserinfo(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Additionaluserinfo.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
                           ResultSetHandler.getColumnValue(resultset,row,1),
                           ResultSetHandler.getColumnValue(resultset,row,2),
                           ResultSetHandler.getColumnValue(resultset,row,3),
                           ResultSetHandler.getColumnValue(resultset,row,4),
                           ResultSetHandler.getColumnValue(resultset,row,5),
                           ResultSetHandler.getColumnValue(resultset,row,6),
                           NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,7)),
                           NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,8)),
                           total)
  end
  
end