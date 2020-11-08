defmodule ExApp.UserCleanupTask do
 
  use Task
  alias ExApp.SessionCleanupServiceApp
  #alias ExApp.DateUtil

  def start_link(opts) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run(_opts) do
    timeout = 45000
  	#IO.puts("UserCleanupTask: Secure wait for depencies start: going sleep for #{timeout} miliseconds before really start.")
    :timer.sleep(timeout)
    runLoop()
  end
  
  defp runLoop() do
    timeout = 600000
    try do
      #t1 = DateUtil.getDateTimeNowMillis()
      SessionCleanupServiceApp.makeCleanup()
      #t2 = DateUtil.getDateTimeNowMillis()
      #IO.puts("UserCleanupTask: runLoop() duration: #{(t2 - t1)}ms going sleep for #{timeout} ms")
      :timer.sleep(timeout)
      runLoop()
    rescue
      _ -> rescueRunLoop()
    end
  end
  
  defp rescueRunLoop() do
  	timeout = 15000
  	#IO.puts("UserCleanupTask: Rescued from Error: going sleep for #{timeout} miliseconds before retry.")
    :timer.sleep(timeout)
    runLoop()
  end
  
end