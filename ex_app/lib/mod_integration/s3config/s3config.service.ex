defmodule ExApp.S3ConfigService do

  use ExApp.BaseServiceSecure
  alias ExApp.Config.DAOService
  alias ExApp.DateUtil
  alias ExApp.NumberUtil
  alias ExApp.MapUtil
  alias ExApp.ResultSetHandler
  alias ExApp.S3Config
  
  
  def userIsOwner(userId) do
  	resultset = DAOService.load("select id from s3config where ownerId = ? limit 1",[userId])
	(nil != resultset and resultset.num_rows > 0)
  end
  
  def loadById(id) do
    sql = """
	      select id, bucketName, bucketUrl, region, version, keyy, secret, active, ownerId from s3config where id = ? limit 1
	      """
	resultset = DAOService.load(sql,[id])
	cond do
      (nil == resultset or resultset.num_rows == 0) -> nil
      true -> getS3Config(resultset)
    end
  end
  
  def create(paramValues) do
    sql = """
          insert into s3config(bucketName,bucketUrl,region,version,keyy,secret,active,ownerId,created_at) values (?,?,?,?,?,?,?,?,?)
	      """
    DAOService.insert(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false)])
  end
  
  def update(id,paramValues) do
    sql = """
          update s3config set bucketName = ?, bucketUrl = ?, region = ?, version = ?, keyy = ?, 
          secret = ?, active = ?, updated_at = ? where id = ?
	      """
    DAOService.update(sql,paramValues ++ [DateUtil.getNowToSql(0,false,false),id])
  end
  
  def updateDependencies(_id,_s3config) do
    
  end
  
  def loadAll(page,rows,conditions,deletedAt,_mapParams) do
    limit = cond do
      (page > 0 and rows > 0) -> " limit #{((page - 1) * rows)},#{rows}"
      true -> ""
    end
    resultset = DAOService.load("select count(id) from s3config where #{deletedAt} #{conditions}",[])
    total = NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,0,0))
    sql = """
          select id, bucketName, bucketUrl, region, version, keyy, secret, active, 
          ownerId from s3config where #{deletedAt} #{conditions} order by id asc #{limit}
          """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> [S3Config.new(0,nil,nil,nil,nil,nil,nil,0,0,0)]
      true -> parseResults(resultset,total,[],0) 
    end
  end
  
  def loadAllForPublic(_page,_rows,_conditions,_deletedAt,_mapParams) do
    [S3Config.new(0,nil,nil,nil,nil,nil,nil,0,0,0)]
  end
  
  def delete(id) do
    DAOService.update("update s3config set deleted_at = ? where id = ?",[DateUtil.getNowToSql(0,false,false),id])
  end
  
  def unDrop(id) do
    DAOService.update("update s3config set deleted_at = null where id = ?",[id])
  end
  
  def trullyDrop(id) do
    DAOService.delete("delete from s3config where id = ?",[id])
  end
  
  def alreadyHasActive(id,deletedAt) do
    sql = "select id from s3config where #{deletedAt} and id <> ? and active = true"
    resultset = DAOService.load(sql,[id])
    (nil != resultset and resultset.num_rows > 0)
  end
  
  defp parseResults(resultset,totalRows,arrayMap,row) do
    cond do
      (nil == resultset or resultset.num_rows == 0 or row >= resultset.num_rows) -> arrayMap
      true -> parseResults(resultset,totalRows,arrayMap ++ [getS3Config(resultset,row,totalRows)],row + 1)
    end
  end
  
  defp getS3Config(resultset,row \\ 0,totalRows \\ nil) do
    total = cond do
      (row == 0) -> totalRows
      true -> nil
    end
    S3Config.new(NumberUtil.toInteger(ResultSetHandler.getColumnValue(resultset,row,0)),
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
  
  def setS3Config() do
    sql = """
	      select id, bucketName, bucketUrl, region, version, keyy, secret, active, ownerId from s3config where active = true limit 1
	      """
    resultset = DAOService.load(sql,[])
    cond do
      (nil == resultset or resultset.num_rows == 0) -> false
      true -> applyS3Config(resultset)
    end
  end
  
  defp applyS3Config(resultset) do
    s3config = getS3Config(resultset)
    Application.put_env(:ex_aws, :bucketName, MapUtil.get(s3config,:bucketName))
    Application.put_env(:ex_aws, :bucketUrl, MapUtil.get(s3config,:bucketUrl))
    Application.put_env(:ex_aws, :version, MapUtil.get(s3config,:version))
    Application.put_env(:ex_aws, :access_key_id, MapUtil.get(s3config,:key))
    Application.put_env(:ex_aws, :secret_access_key, MapUtil.get(s3config,:secret))
    Application.put_env(:ex_aws, :region, MapUtil.get(s3config,:region))
    true
  end
    
end

