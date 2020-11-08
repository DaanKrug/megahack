defmodule ExApp.Application do
  
  @moduledoc false

  use Application

  def start(_type, _args) do
    Supervisor.start_link(children(), opts())
  end
  
  def children() do
  	[
  	  ExApp.App.Repo,
  	  ExApp.Session.Repo,
  	  ExApp.BillingControl.Repo,
  	  ExApp.Log.Repo,
  	  ExApp.Queue.Repo,
  	  ExApp.Config.Repo,
      ExApp.Endpoint,
      #ExApp.TimeSyncTask,
      ExApp.SimpleMailDispatchTaskStarter,
      ExApp.SimpleMailEnqueueTaskStarter,
      ExApp.UserCleanupTaskStarter
  	]
  end
  
  def opts() do 
  	[strategy: :one_for_one, name: ExApp.Supervisor]
  end 
  
end
