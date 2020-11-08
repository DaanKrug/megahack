use Mix.Config

config :logger, level: :info
config :cors_plug,
  send_preflight_response?: true,
  credentials: false,
  origin: ["*"],
  max_age: 86400,
  methods: ["POST","PUT","PATCH","OPTIONS"],
  headers: [
	        "Authorization",
	        "Content-Type",
	        "Accept",
	        "Origin",
	        "User-Agent",
	        "DNT",
	        "Cache-Control",
	        "X-Mx-ReqToken",
	        "Keep-Alive",
	        "X-Requested-With",
	        "If-Modified-Since",
	        "X-CSRF-Token",
	        "Access-Control-Allow-Headers",
	        "Access-Control-Request-Method",
	        "Access-Control-Request-Headers",
	        "X-Auth-Token",
	        "Access-Control-Allow-Origin"
	      ]

config :ex_aws,
  access_key_id: "",
  secret_access_key: "",
  region: ""
  
config :ex_app, ExApp.Endpoint, port: 8080, protocol_options: [idle_timeout: 30_000]
config :ex_app, proxyPrefix: "megahack2020"
config :ex_app, adminEmails: "daniel-krug@hotmail.com"
config :ex_app, accepptHosts: ["localhost","www.megahack2020.skallerten.com.br","megahack2020.skallerten.com.br"]
config :ex_app, autogendir: "/var/www/html"
config :ex_app, hackney: [pool: :default]

config :ex_app, ecto_repos: [
  ExApp.App.Repo,
  ExApp.Session.Repo,
  ExApp.BillingControl.Repo,
  ExApp.Log.Repo,
  ExApp.Queue.Repo,
  ExApp.Config.Repo
]
config :ex_app, ExApp.App.Repo, []
config :ex_app, ExApp.Session.Repo, []
config :ex_app, ExApp.BillingControl.Repo, []
config :ex_app, ExApp.Log.Repo, []
config :ex_app, ExApp.Queue.Repo, []
config :ex_app, ExApp.Config.Repo, []

config :ex_app, ExApp.GenericSMTPMailer,
  adapter: Bamboo.SMTPAdapter,
  chained_adapter: Bamboo.SMTPAdapter,
  server: "",
  port: 587,
  username: "",
  password: "",
  api_key: "my_api_key",
  tls: :always, #:if_available, # can be `:always` or `:never`
  allowed_tls_versions: {:system, "ALLOWED_TLS_VERSIONS"}, #[:"tlsv1", :"tlsv1.1", :"tlsv1.2"],
  ssl: false,
  retries: 0,
  no_mx_lookups: false, # can be `true`
  auth: :always
  

import_config "#{Mix.env()}.exs"