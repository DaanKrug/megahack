defmodule ExApp.Cell do

  def new(value,header \\ false,vheader \\ false,clazz \\ "text",
          colspan \\ 1,rowspan \\ 1,title \\ nil,table \\ nil) do
    %{
      value: value,
      header: header,
      vheader: vheader,
      clazz: clazz,
      colspan: colspan,
      rowspan: rowspan,
      title: title,
      table: table
    }
  end

end