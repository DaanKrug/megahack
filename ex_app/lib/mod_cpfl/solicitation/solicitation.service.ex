defmodule ExApp.SolicitationService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Solicitation 
  
  def clientIsIn(clientId) do
    sql = "select id from solicitation where a15_clientid = ? limit 1"
	resultset = DAOService.load(sql,[clientId])
	(nil != resultset and resultset.num_rows > 0)
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
          active, ownerId from solicitation where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getSolicitation(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into solicitation(a1_name,
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
          active,ownerId,created_at) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update solicitation set
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
          active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateByClient(clientId,clientName,clientCpf,clientCnpj) do
    sql = """
          update solicitation set
          a1_name = ?,
          a3_cpf = ?,
          a4_cnpj = ?
          where a15_clientid = ?
	      """
    DAOService.update(sql,[clientName,clientCpf,clientCnpj,clientId])
  end
  
  def updateDependencies(_id,_solicitation) do
  
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from solicitation where #{deletedAt} #{conditions}"
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
          active, 
          ownerId from solicitation 
          where #{deletedAt} #{conditions} 
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Solicitation.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [Solicitation.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0,0,0)]
  end 
  
  def delete(id) do
    DAOService.update("update solicitation set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update solicitation set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from solicitation where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getSolicitation(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getSolicitation(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Solicitation.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
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