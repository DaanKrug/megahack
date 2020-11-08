defmodule ExApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_app,
      version: "1.0.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :plug, :poison, :cowboy, :plug_cowboy, :httpoison, :bamboo, :bamboo_smtp, 
                           :bamboo_config_adapter, :poolboy, :myxql, :ecto_sql, :ecto, :eex, :sntp],
      mod: {ExApp.Application, []}
    ]
  end
  
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:bcrypt_elixir, "~> 2.0"},
        {:myxql, "~> 0.2.10"},
        {:ecto, "~> 3.2.0"},
        {:ecto_sql, "~> 3.2.0"},
        {:poolboy, "1.5.1"},
        {:poison, "~> 4.0.1"},
        {:plug, "~> 1.8.3"},
        {:cowboy, "~> 2.4"},
        {:plug_cowboy, "~> 2.0"},
        {:cors_plug, "~> 2.0"},
        {:bamboo, "~> 1.2.0"},
        {:bamboo_smtp, "~> 2.1.0"},
        {:bamboo_config_adapter, "~> 1.0.0"},
        {:httpoison, "~> 1.6"},
        {:ex_aws, "~> 2.1"},
	    {:ex_aws_s3, "~> 2.0"},
	    {:hackney, "~> 1.15"},
	    {:sntp, "~> 0.2.1"}
    ]
  end
end

