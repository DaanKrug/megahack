defmodule ExApp.ConsumerunitService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Consumerunit 
  
  
  def loadConsumerUnitIdsByCep(cep,clientId) do
    sql = "select GROUP_CONCAT(id) from consumerunit where a5_cep = ? and a15_clientid <> ?"
  	resultset = DAOService.load(sql,[cep,clientId])
  	ids = cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> ResultSetHandler.getColumnValue(resultset,0,0)
    end
    cond do
      (nil == ids or StringUtil.trim(ids) == "") -> "0"
      true -> ids
    end
  end
  
  def loadById(id) do
    sql = """
	      select id, a1_name,
          a3_cpf,
          a4_cnpj,
          a2_caracteristic,
          a5_cep,
          a6_uf,
          a7_city,
          a8_street,
          a9_number,
          a10_compl1type,
          a11_compl1desc,
          a12_compl2type,
          a13_compl2desc,
          a14_reference,
          a15_clientid,
          a16_solicitationid, ownerId from consumerunit where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getConsumerunit(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into consumerunit(a1_name,
          a3_cpf,
          a4_cnpj,
          a2_caracteristic,
          a5_cep,
          a6_uf,
          a7_city,
          a8_street,
          a9_number,
          a10_compl1type,
          a11_compl1desc,
          a12_compl2type,
          a13_compl2desc,
          a14_reference,
          a15_clientid,
          a16_solicitationid,ownerId,created_at) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update consumerunit set a1_name = ?,
          a3_cpf = ?,
          a4_cnpj = ?,
          a2_caracteristic = ?,
          a5_cep = ?,
          a6_uf = ?,
          a7_city = ?,
          a8_street = ?,
          a9_number = ?,
          a10_compl1type = ?,
          a11_compl1desc = ?,
          a12_compl2type = ?,
          a13_compl2desc = ?,
          a14_reference = ?,
          a15_clientid = ?,
          a16_solicitationid = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateByClient(clientId,clientName,clientCpf,clientCnpj) do
    sql = """
          update consumerunit set
          a1_name = ?,
          a3_cpf = ?,
          a4_cnpj = ?
          where a15_clientid = ?
	      """
    DAOService.update(sql,[clientName,clientCpf,clientCnpj,clientId])
  end
  
  def updateDependencies(_id,_consumerunit) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from consumerunit where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, a1_name,
          a3_cpf,
          a4_cnpj,
          a2_caracteristic,
          a5_cep,
          a6_uf,
          a7_city,
          a8_street,
          a9_number,
          a10_compl1type,
          a11_compl1desc,
          a12_compl2type,
          a13_compl2desc,
          a14_reference,
          a15_clientid,
          a16_solicitationid, 
          ownerId from consumerunit 
          where #{deletedAt} #{conditions} 
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Consumerunit.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [Consumerunit.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0)]
  end 
  
  def delete(id) do
    DAOService.update("update consumerunit set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update consumerunit set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from consumerunit where id = ?",[id])
  end
  
  def deleteBySolicitationId(solicitationId) do
    DAOService.delete("delete from consumerunit where a16_solicitationid = ?",[solicitationId])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getConsumerunit(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getConsumerunit(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Consumerunit.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
                     ResultSetHandler.getColumnValue(resultset,row,1),
                     ResultSetHandler.getColumnValue(resultset,row,2),
                     ResultSetHandler.getColumnValue(resultset,row,3),
                     ResultSetHandler.getColumnValue(resultset,row,4),
                     ResultSetHandler.getColumnValue(resultset,row,5),
                     ResultSetHandler.getColumnValue(resultset,row,6),
                     ResultSetHandler.getColumnValue(resultset,row,7),
                     ResultSetHandler.getColumnValue(resultset,row,8),
                     ResultSetHandler.getColumnValue(resultset,row,9),
                     ResultSetHandler.getColumnValue(resultset,row,10),
                     ResultSetHandler.getColumnValue(resultset,row,11),
                     ResultSetHandler.getColumnValue(resultset,row,12),
                     ResultSetHandler.getColumnValue(resultset,row,13),
                     ResultSetHandler.getColumnValue(resultset,row,14),
                     NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,15)),
                     NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,16)),
                     NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,17)),
                     total)
  end
  
end