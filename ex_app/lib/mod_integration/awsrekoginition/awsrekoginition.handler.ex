defmodule ExApp.AwsrekoginitionHandler do

  alias ExApp.SanitizerUtil
  alias ExApp.MessagesUtil
  alias ExApp.MapUtil
  alias ExApp.StringUtil
  alias ExApp.FileValidator
  alias ExApp.ReturnUtil
  
  def makeRekognition(mapParams) do
    fileName = FileValidator.getFileName(mapParams)
	fileBase64 = MapUtil.get(mapParams,:file)
	cond do
	  (SanitizerUtil.hasEmpty([fileName])) -> MessagesUtil.systemMessage(100168)
	  (!FileValidator.validateMime(fileName,fileBase64)) -> MessagesUtil.systemMessage(100169)
	  true -> rekognition(fileBase64)
	end
  end
  
  defp rekognition(fileBase64) do
    # detectCustomLabels 
    # "ProjectVersionArn" => "arn:aws:s3:::custom-labels-console-us-west-2-d89c4fe0be" 
    # {"x-amz-target", "RekognitionService.DetectLabels"}
    binary = fileBase64 |> StringUtil.split(",") |> Enum.at(1) 
    configuration = ExAws.Config.new(:rekognition)
    result = %ExAws.Operation.JSON{
      before_request: nil,
	  data: %{ 
	    "Image" => %{ "Bytes" => binary }
	  },
	  headers: [
		{"content-type", "application/x-amz-json-1.1"},
		{"x-amz-target", "RekognitionService.DetectLabels"}
	  ],
      http_method: :post,
      params: %{},
      path: "/",
      service: :rekognition,
      stream_builder: nil  
	} |> ExAws.Operation.perform(configuration)
    result = result |> Tuple.to_list() |> Enum.at(1)
    #IO.inspect(result)
    ReturnUtil.getOperationSuccess(200,result,nil)
  end
  
  
end