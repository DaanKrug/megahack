defmodule ExApp.SimpleMailDispatchTask do
 
  use Task
  alias ExApp.SimpleMailHandlerTask
  alias ExApp.DateUtil

  def start_link(opts) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run(_opts) do
  	timeout = 15000
  	#IO.puts("SimpleMailDispatchTask: Secure wait for depencies start: going sleep for #{timeout} miliseconds before really start.")
    :timer.sleep(timeout)
    runLoop()
  end
  
  defp runLoop() do
    try do
      t1 = DateUtil.getDateTimeNowMillis()
      mailerConfigs = SimpleMailHandlerTask.loadConfigsForMailing()
      mailerConfigs = SimpleMailHandlerTask.dispatchQueuedMailsPriorityZero(mailerConfigs)
      mailerConfigs = SimpleMailHandlerTask.dispatchQueuedMailsPriorityNonZero(mailerConfigs,"0")
      SimpleMailHandlerTask.updateConfigsAfterMailed(mailerConfigs)
      t2 = DateUtil.getDateTimeNowMillis()
      diff = t2 - t1
      sleepTime = cond do
        (nil == mailerConfigs or length(mailerConfigs) == 0) -> 60000
        (diff > 60000) -> 35000
        (diff > 30000) -> 25000
        (diff > 20000) -> 15000
        (diff > 10000) -> 9000
        (diff > 5000) -> 4000
        (diff > 4000) -> 3000
        true -> 2000
      end
      #IO.puts("SimpleMailDispatchTask: runLoop() duration: #{diff}ms going sleep for #{sleepTime} ms")
      #IO.puts("SimpleMailDispatchTask: Execution OK: going sleep for #{sleepTime} miliseconds.")
      :timer.sleep(sleepTime)
      runLoop()
    rescue
      _ -> rescueRunLoop()
    end
  end
  
  defp rescueRunLoop() do
  	timeout = 15000
  	#IO.puts("SimpleMailDispatchTask: Rescued from Error: going sleep for #{fiveSeconds} miliseconds before retry.")
    :timer.sleep(timeout)
    runLoop()
  end
  
end




