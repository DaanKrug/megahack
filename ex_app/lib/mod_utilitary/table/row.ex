defmodule ExApp.Row do

  alias ExApp.MapUtil

  def new(clazz \\ "") do
    %{
      clazz: clazz,
      cells: []
    }
  end
  
  def addCell(row,cell) do
    cells = (row |> MapUtil.get(:cells)) ++ [cell]
    MapUtil.replace(row,:cells,cells)
  end

end