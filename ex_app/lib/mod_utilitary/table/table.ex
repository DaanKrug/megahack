defmodule ExApp.Table do

  alias ExApp.MapUtil

  def new(clazz \\ "") do
    %{
      clazz: clazz,
      rows: [],
      total1: 0,
      total2: 0,
      total3: 0
    }
  end
  
  def addRow(table,row) do
    rows = (table |> MapUtil.get(:rows)) ++ [row]
    MapUtil.replace(table,:rows,rows)
  end

end