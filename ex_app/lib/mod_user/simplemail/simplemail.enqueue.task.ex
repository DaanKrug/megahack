defmodule ExApp.SimpleMailEnqueueTask do
 
  use Task
  alias ExApp.SimpleMailHandlerTask
  #alias ExApp.DateUtil

  def start_link(opts) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run(_opts) do
  	timeout = 15000
  	#IO.puts("SimpleMailEnqueueTask: Secure wait for depencies start: going sleep for #{timeout} miliseconds before really start.")
    :timer.sleep(timeout)
    runLoop()
  end
  
  defp runLoop() do
    timeout = 10000
    try do
      #t1 = DateUtil.getDateTimeNowMillis()
      SimpleMailHandlerTask.markToResendFailedQueuedMails()
      SimpleMailHandlerTask.createQueuedMails()
      #t2 = DateUtil.getDateTimeNowMillis()
      #IO.puts("SimpleMailEnqueueTask: runLoop() duration: #{(t2 - t1)}ms going sleep for #{timeout} ms")
      #IO.puts("SimpleMailEnqueueTask: Execution OK: going sleep for #{timeout} miliseconds.")
      :timer.sleep(timeout)
      runLoop()
    rescue
      _ -> rescueRunLoop()
    end
  end
  
  defp rescueRunLoop() do
  	timeout = 15000
  	#IO.puts("SimpleMailEnqueueTask: Rescued from Error: going sleep for #{timeout} miliseconds before retry.")
    :timer.sleep(timeout)
    runLoop()
  end
  
end