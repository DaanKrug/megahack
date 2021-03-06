defmodule ExApp.App.Repo do
  
  use Ecto.Repo, otp_app: :ex_app, adapter: Ecto.Adapters.MyXQL
  alias ExApp.Enviroment.Reader
  
  def init(_type, config) do
    config = Keyword.put(config, :hostname,               Reader.readKeyValue("APPDB_HOST"))
    config = Keyword.put(config, :port, String.to_integer(Reader.readKeyValue("APPDB_PORT")))
    config = Keyword.put(config, :database,               Reader.readKeyValue("APPDB_DATABASE"))
    config = Keyword.put(config, :username,               Reader.readKeyValue("APPDB_USERNAME"))
    config = Keyword.put(config, :password,               Reader.readKeyValue("APPDB_PASSWORD"))
    config = Keyword.put(config, :pool_size, 5)
    config = Keyword.put(config, :timeout, 60_000)
    config = Keyword.put(config, :ownership_timeout, 60_000)
    config = Keyword.put(config, :queue_target, 500)
    config = Keyword.put(config, :queue_interval, 10_000)
	{:ok, config}
  end
  
end