defmodule ExApp.ReturnUtil do

  def getOperationError(msgError \\ "") do
    %{
      objectClass: "OperationError",
      code: 500,
      msg: msgError
    }
  end
  
  def getOperationSuccess(codeReturn,msgSucess,objectReturn \\ nil) do
    %{
      objectClass: "OperationSuccess",
      code: codeReturn,
      msg: msgSucess,
      object: objectReturn
    }
  end
  
  def getValidationResult(codeReturn,msgResult) do
    %{
      objectClass: "ValidationResult",
      code: codeReturn,
      msg: msgResult
    }
  end
  
  def getReport(html) do
    [%{
      objectClass: "Report",
      code: 205,
      msg: html
    }]
  end
  

end