defmodule ExApp.S3FileHandler do

  alias ExApp.FileValidator
  alias ExApp.StringUtil
  alias ExApp.MapUtil
  alias ExApp.AuthorizerUtil
  alias ExApp.AppConfigService

  def validateAndUploadS3(fileName,fileBase64,ownerId) do
    cond do
      (!FileValidator.validateMime(fileName,fileBase64)) -> nil
      true -> uploadToS3(fileName,fileBase64,ownerId)
    end
  end
  
  def deleteFromS3(link,ownerId) do
    cond do
      (!(String.contains?("#{link}",".amazonaws.com"))) -> true
      true -> dropFromS3(link,ownerId)
    end
  end
  
  defp uploadToS3(fileName,fileBase64,ownerId) do
    appconfigs = AppConfigService.loadAllForPublic(0,0,nil,AuthorizerUtil.getDeletedAt(nil,nil),nil)
    appId = cond do
      (length(appconfigs) > 0) -> appconfigs |> Enum.at(0) |> MapUtil.get(:id)
      true -> nil
    end  
    bucketName = Application.get_env(:ex_aws,:bucketName) 
    cond do
      (nil == appId or StringUtil.trim(appId) == "" or nil == bucketName or StringUtil.trim(bucketName) == "") -> nil
      true -> putToS3Bucket(bucketName,"#{appId}_#{ownerId}/#{fileName}",fileBase64)
    end
  end
  
  defp putToS3Bucket(bucketName,fileDir,fileBase64) do
    try do
      binary = fileBase64 |> StringUtil.split(",") |> Enum.at(1) |> Base.decode64!()
      uploadedFile = ExAws.S3.put_object(bucketName,fileDir,binary,[acl: :public_read])          
      file = ExAws.request!(uploadedFile)
      cond do
        (nil == file or !file) -> nil
        true -> "#{Application.get_env(:ex_aws,:bucketUrl)}/#{fileDir}"
      end
    rescue
      _ -> nil
    end
  end
  
  defp dropFromS3(link,ownerId) do
    appconfigs = AppConfigService.loadAllForPublic(0,0,nil,AuthorizerUtil.getDeletedAt(nil,nil),nil)
    appId = cond do
      (length(appconfigs) > 0) -> MapUtil.get(Enum.at(appconfigs,0),:id)
      true -> nil
    end
    bucketName = Application.get_env(:ex_aws,:bucketName) 
    linkParts = StringUtil.split(link,"/")
    fileDir = "#{appId}_#{ownerId}/#{Enum.at(linkParts,length(linkParts) - 1)}"
    deletedFile = ExAws.S3.delete_object(bucketName,fileDir) 
    file = ExAws.request!(deletedFile)
    cond do
      (nil == file or MapUtil.get(file,:status_code) == 204) -> true
      true -> false
    end
  end
  
end

