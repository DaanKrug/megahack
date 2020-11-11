defmodule ExApp.ClientService do

  use ExApp.BaseServiceSecure
  alias ExApp.App.DAOService
  alias ExApp.DateUtil
  alias ExApp.MapUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.Client 
  alias ExApp.ConsumerunitService
  alias ExApp.SolicitationService
  
  
  def loadById(id) do
    sql = """
	      select id, a1_name,
          a2_type,
          a3_cpf,
          a4_cnpj,
          a5_birthdate,
          a6_doctype,
          a7_document,
          a8_gender,
          a9_email,
          a10_phone,
          a11_cep,
          a12_uf,
          a13_city,
          a14_street,
          a15_number,
          a16_compl1type,
          a17_compl1desc,
          a18_compl2type,
          a19_compl2desc, ownerId from client where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getClient(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into client(a1_name,
          a2_type,
          a3_cpf,
          a4_cnpj,
          a5_birthdate,
          a6_doctype,
          a7_document,
          a8_gender,
          a9_email,
          a10_phone,
          a11_cep,
          a12_uf,
          a13_city,
          a14_street,
          a15_number,
          a16_compl1type,
          a17_compl1desc,
          a18_compl2type,
          a19_compl2desc,ownerId,created_at) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update client set a1_name = ?,
          a2_type = ?,
          a3_cpf = ?,
          a4_cnpj = ?,
          a5_birthdate = ?,
          a6_doctype = ?,
          a7_document = ?,
          a8_gender = ?,
          a9_email = ?,
          a10_phone = ?,
          a11_cep = ?,
          a12_uf = ?,
          a13_city = ?,
          a14_street = ?,
          a15_number = ?,
          a16_compl1type = ?,
          a17_compl1desc = ?,
          a18_compl2type = ?,
          a19_compl2desc = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(id,client) do
    clientName = MapUtil.get(client,:a1_name)
    clientCpf = MapUtil.get(client,:a3_cpf)
    clientCnpj = MapUtil.get(client,:a4_cnpj)
    ConsumerunitService.updateByClient(id,clientName,clientCpf,clientCnpj)
    SolicitationService.updateByClient(id,clientName,clientCpf,clientCnpj)
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    sql = "select count(id) from client where #{deletedAt} #{conditions}"
    resultset = DAOService.load(sql,[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, a1_name,
          a2_type,
          a3_cpf,
          a4_cnpj,
          a5_birthdate,
          a6_doctype,
          a7_document,
          a8_gender,
          a9_email,
          a10_phone,
          a11_cep,
          a12_uf,
          a13_city,
          a14_street,
          a15_number,
          a16_compl1type,
          a17_compl1desc,
          a18_compl2type,
          a19_compl2desc, 
          ownerId from client 
          where #{deletedAt} #{conditions} 
          order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) 
        -> [Client.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [Client.new(0,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,0,0)]
  end 
  
  def delete(id) do
    DAOService.update("update client set deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update client set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from client where id = ?",[id])
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,
                           arrayMap ++ [getClient(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getClient(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    Client.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
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
               ResultSetHandler.getColumnValue(resultset,row,15),
               ResultSetHandler.getColumnValue(resultset,row,16),
               ResultSetHandler.getColumnValue(resultset,row,17),
               ResultSetHandler.getColumnValue(resultset,row,18),
               ResultSetHandler.getColumnValue(resultset,row,19),
               NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,20)),
               total)
  end
  
end