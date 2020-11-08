defmodule ExApp.AppConfigService do

  use ExApp.BaseServiceSecure
  alias ExApp.Config.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.ResultSetHandler
  alias ExApp.AppConfig
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from appconfig where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, name, description, site, usePricingPolicy, pricingPolicy, usePrivacityPolicy, privacityPolicy,
          useUsetermsPolicy, usetermsPolicy, useUsecontractPolicy, usecontractPolicy, 
          useAuthorInfo, authorInfo, active, ownerId 
          from appconfig where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getAppConfig(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into appconfig(name,description,site,usePricingPolicy,pricingPolicy,
          usePrivacityPolicy,privacityPolicy,useUsetermsPolicy,usetermsPolicy,
          useUsecontractPolicy,usecontractPolicy,useAuthorInfo,authorInfo,
          active,ownerId,created_at) 
          values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update appconfig set name = ?, description = ?, site = ?, usePricingPolicy = ?, pricingPolicy = ?, 
          usePrivacityPolicy = ?, privacityPolicy = ?, useUsetermsPolicy = ?, usetermsPolicy = ?, 
          useUsecontractPolicy = ?, usecontractPolicy = ?, useAuthorInfo = ?, authorInfo = ?,
          active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_appconfig) do
  	
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from appconfig where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, name, description, site, usePricingPolicy, pricingPolicy, usePrivacityPolicy, privacityPolicy,
          useUsetermsPolicy, usetermsPolicy, useUsecontractPolicy, usecontractPolicy, 
          useAuthorInfo, authorInfo, active, ownerId 
          from appconfig where #{deletedAt} #{conditions} order by id asc
          #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (resultset.num_rows == 0) 
        -> [AppConfig.new(0,nil,nil,nil,0,nil,0,nil,0,nil,0,nil,0,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0)
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,deletedAt,mapParams) do
    loadAll(1,1,' and active = true ',deletedAt,mapParams)
  end
  
  def delete(id) do
    DAOService.update("update appconfig set active = false, deleted_at = ? where id = ?",
                      [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update appconfig set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from appconfig where id = ?",[id])
  end
  
  def alreadyHasActive(id,deletedAt) do
    sql = "select id from appconfig where #{deletedAt} and id <> ? and active = true"
    resultset = DAOService.load(sql,[id])
    (nil != resultset and resultset.num_rows > 0)
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getAppConfig(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getAppConfig(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    AppConfig.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
		          ResultSetHandler.getColumnValue(resultset,row,1),
		          ResultSetHandler.getColumnValue(resultset,row,2),
		          ResultSetHandler.getColumnValue(resultset,row,3),
		          NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,4)),
		          ResultSetHandler.getColumnValue(resultset,row,5),
		          NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,6)),
		          ResultSetHandler.getColumnValue(resultset,row,7),
		          NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,8)),
		          ResultSetHandler.getColumnValue(resultset,row,9),
 		          NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,10)),
		          ResultSetHandler.getColumnValue(resultset,row,11),
		          NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,12)),
		          ResultSetHandler.getColumnValue(resultset,row,13),
                  NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,14)),
                  NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,15)),
                  total)
  end
  
end

