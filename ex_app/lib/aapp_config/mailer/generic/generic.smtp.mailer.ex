defmodule ExApp.GenericSMTPMailer do

  require Logger
  alias Bamboo.Formatter
  alias ExApp.MapUtil

  otp_app = :ex_app
  
  def deliverNow(email,dynamicConfigOverrides \\ %{}) do
    config = buildConfig(dynamicConfigOverrides)
    deliverNow(config.adapter,email,config)
  end
  
  defp deliverNow(adapter,email,config) do
    email = email |> validateAndNormalize(adapter)
    cond do
      (nil == email or nil == MapUtil.get(email,:to)) -> debuggUnsent(email)
      true -> deliverAndDebuggSent(email,config,adapter)
    end
    email
  end
  
  defp deliverAndDebuggSent(email,config,adapter) do
    Logger.debug(fn ->
      """
      Sending email with #{inspect(adapter)}:
      #{inspect(email, limit: 150)}
      """
    end)
    adapter.deliver(email,config)
  end

  defp debuggUnsent(email) do
    Logger.debug(fn ->
      """
      Email was not sent because recipients are empty.
      Full email - #{inspect(email, limit: 150)}
      """
    end)
  end

  defp validateAndNormalize(email,adapter) do
    email |> validate(adapter) |> normalizeAddresses()
  end

  defp validate(email,adapter) do
    email
      |> validateFromAddress()
      |> validateRecipients()
      |> validateAttachmentSupport(adapter)
  end

  defp validateAttachmentSupport(%{attachments: []} = email, _adapter) do
    email
  end

  defp validateAttachmentSupport(email,adapter) do
    if(function_exported?(adapter, :supports_attachments?, 0) and adapter.supports_attachments?()) do
      email
    else
      raise("the #{adapter} does not support attachments yet.")
    end
  end

  defp validateFromAddress(%{from: nil}) do
    raise(Bamboo.EmptyFromAddressError,nil)
  end

  defp validateFromAddress(%{from: {_, nil}}) do
    raise(Bamboo.EmptyFromAddressError,nil)
  end

  defp validateFromAddress(email) do
    email
  end

  defp validateRecipients(%Bamboo.Email{} = email) do
    if(Enum.all?(Enum.map([:to, :cc, :bcc], &Map.get(email,&1)),&isNilRecipient?/1)) do
      raise(Bamboo.NilRecipientsError,email)
    else
      email
    end
  end

  defp isNilRecipient?(nil) do
    true
  end
  defp isNilRecipient?({_, nil}) do
    true
  end
  defp isNilRecipient?([]) do
    false
  end
  defp isNilRecipient?([_ | _] = recipients) do
    Enum.all?(recipients, &isNilRecipient?/1)
  end
  defp isNilRecipient?(_) do
    false
  end

  def normalizeAddresses(email) do
    %{
      email
      | from: format(email.from, :from),
        to: format(List.wrap(email.to), :to),
        cc: format(List.wrap(email.cc), :cc),
        bcc: format(List.wrap(email.bcc), :bcc)
    }
  end

  defp format(record,type) do
    Formatter.format_email_address(record, %{type: type})
  end
  
  defp buildConfig(dynamicConfigOverrides) do
    buildConfig(__MODULE__,unquote(otp_app),dynamicConfigOverrides)
  end

  defp buildConfig(mailer,otp_app,dynamicConfigOverrides) do
    config = Application.fetch_env!(otp_app,mailer)
    map = Map.new(config)
    map = Map.merge(map,dynamicConfigOverrides)
    handleAdapterConfig(map)
  end

  defp handleAdapterConfig(base_config = %{adapter: adapter}) do
    adapter.handle_config(base_config)
      |> Map.put_new(:deliver_later_strategy,Bamboo.TaskSupervisorStrategy)
  end

end