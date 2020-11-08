defmodule ExApp.MathUtil do
  
  def pow(base,expoent) do
    cond do
      (expoent == 0) -> 1
      (rem(expoent,2) == 1) -> base * pow(base,expoent - 1)
      true -> powEven(base,expoent)
    end
  end
  
  defp powEven(base,expoent) do
    result = pow(base,div(expoent,2))
    result * result
  end
  
end