defmodule ExApp.TimeSyncTask do
 
  use Task
  alias ExApp.DateUtil
  alias ExApp.SNTPUtil
  alias ExApp.TimeSyncService

  def start_link(opts) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run(_opts) do
    :timer.sleep(10000)
    runLoop()
  end
  
  defp runLoop() do
    try do
      syncronizePtBrTime()
      :timer.sleep(900000)
      runLoop()
    rescue
      _ -> rescueRunLoop()
    end
  end
  
  defp rescueRunLoop() do
  	timeout = 60000
  	IO.puts("TimeSyncTask: Rescued from Error: going sleep for #{timeout} miliseconds before retry.")
    :timer.sleep(timeout)
    runLoop()
  end
  
  defp syncronizePtBrTime() do
    sntp = SNTPUtil.getSNTP()
    now = DateUtil.getDateTimeNowMillis()
    TimeSyncService.create(["pt_br",sntp - now])
  end
  
end