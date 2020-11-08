defmodule ExApp.ImageUtil do

  alias ExApp.StringUtil
  
  def validateUrl(path) do
    path = path |> StringUtil.trim()
    cond do
      (!(String.contains?(path,"https://")) or !(String.contains?(path,"."))) -> ""
      (String.length(path) < 13) -> ""
      (path |> StringUtil.split(":") |> Enum.at(0) != "https") -> ""
      true -> path |> StringUtil.split(".") |> validateUrlExtension()
    end
  end
  
  def validateUrlExtension(arr) do
    ext = Enum.at(arr,length(arr) - 1) |> StringUtil.trim() |> String.downcase()
    Enum.member?(["png","bmp","jpg","jpeg","gif"],ext)
  end
  
end