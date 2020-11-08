defmodule ExApp.FileValidator do

  alias ExApp.StringUtil
  alias ExApp.NumberUtil
  alias ExApp.DateUtil
  alias ExApp.SanitizerUtil
  alias ExApp.MapUtil
  
  def getFileId(mapParams,defaultValue \\ nil) do
    value = NumberUtil.coalesce(MapUtil.get(mapParams,:fileId),defaultValue,true)
    NumberUtil.toInteger(SanitizerUtil.sanitizeAll(value,true,true,0,nil))
  end
  
  def getFileLink(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:fileLink),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,0,"url")
  end
  
  def getName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:name),defaultValue)
    SanitizerUtil.sanitizeAll(StringUtil.capitalize(value),false,true,30,"A-z0-9Name")
  end
  
  def getLink(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:link),defaultValue)
    SanitizerUtil.sanitizeAll(value,false,true,0,"url")
  end
  
  def getFileName(mapParams,defaultValue \\ nil) do
    value = StringUtil.coalesce(MapUtil.get(mapParams,:filename),defaultValue)
    value = SanitizerUtil.sanitizeAll(value,false,true,250,"A-z0-9")
    parts = StringUtil.split(value,".")
    extension = Enum.at(parts,length(parts) - 1) |> String.downcase()
    cond do
      (length(parts) < 2 or !Enum.member?(validUploadExtensions(),extension)) -> nil
      true -> "#{DateUtil.getDateTimeNowMillis()}#{SanitizerUtil.generateRandomFileName(200)}.#{extension}"
    end
  end
  
  def validUploadExtensions() do
    ["jpeg","jpg","png","gif","bmp","pdf","doc","docx","xls","xlsx","ppt","pptx"]
  end
  
  def validateMime(fileName,fileBase64) do
    arr = fileBase64 |> StringUtil.split(";")
    arr = arr |> Enum.at(0) |> StringUtil.split(":")
    mime = arr |> Enum.at(1) |> StringUtil.trim()
    parts = fileName |> StringUtil.split(".")
    ext = Enum.at(parts,length(parts) - 1)
    cond do
      (!Enum.member?(validUploadExtensions(),ext) or MIME.from_path(fileName) != mime) -> false
      (!validateFileContentBase64(mime,fileBase64)) -> false
      true -> true
    end
  end
  
  defp validateFileContentBase64(mimetype,fileBase64) do
    arrayBuffer = fileBase64 |> StringUtil.split(",") |> Enum.at(1) |> Base.decode64!() |> :binary.bin_to_list()
    idx0 = arrayBuffer |> Enum.at(0) |> Integer.to_string(16)
    idx1 = arrayBuffer |> Enum.at(1) |> Integer.to_string(16)
    idx2 = arrayBuffer |> Enum.at(2) |> Integer.to_string(16)
    idx3 = arrayBuffer |> Enum.at(3) |> Integer.to_string(16)
    (mimetype == getMimeByHexHeader(mimetype,"#{idx0}#{idx1}#{idx2}#{idx3}"))
  end
  
  defp getMimeByHexHeader(mimetype,hexHeader) do
    hexHeader = hexHeader |> String.downcase()
    cond do
      (hexHeader == "89504e47") -> "image/png"
      (Enum.member?(["ffd8ffe0","ffd8ffe1","ffd8ffe2","ffd8ffe3","ffd8ffe8"],hexHeader)) -> "image/jpeg"
      (hexHeader == "47494638") -> "image/gif"
      (String.starts_with?(hexHeader,"424d")) -> "image/bmp"
      (hexHeader == "25504446") -> "application/pdf"
      (hexHeader == "d0cf11e0" and mimetype == "application/vnd.ms-excel") -> mimetype
      (hexHeader == "d0cf11e0" and mimetype == "application/msword") -> mimetype
      (hexHeader == "d0cf11e0" and mimetype == "application/vnd.ms-powerpoint") -> mimetype
      (Enum.member?(["504b0304","504b0506","504b0708"],hexHeader) 
        and mimetype == "application/vnd.openxmlformats-officedocument.wordprocessingml.document") -> mimetype
      (Enum.member?(["504b0304","504b0506","504b0708"],hexHeader) 
        and mimetype == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet") -> mimetype
      (Enum.member?(["504b0304","504b0506","504b0708"],hexHeader) 
        and mimetype == "application/vnd.openxmlformats-officedocument.presentationml.presentation") -> mimetype
      true -> nil
    end
  end
  
end

