defmodule LivechatWeb.ChatView do
  use LivechatWeb, :view

  alias Livechat.Chat.Message

  use Timex

  def edited?(%Message{} = message) do
    message.inserted_at != message.updated_at
  end

  def day_changed?(new_date, nil), do: true

  def day_changed?(new_message, old_message) do
    new_message.inserted_at.day != old_message.inserted_at.day
  end

  def format_time(datetime) do
    datetime
    |> Timex.to_datetime(Timex.Timezone.Local.lookup())
    |> Timex.format!("%l:%M%P", :strftime)
  end

  def format_datetime(datetime) do
    datetime
    |> Timex.to_datetime(Timex.Timezone.Local.lookup())
    |> Timex.format!("%l:%M%P on %A, %B %e", :strftime)
  end

  def format_date(datetime) do
    datetime
    |> Timex.to_datetime(Timex.Timezone.Local.lookup())
    |> Timex.format!("%A, %B %e", :strftime)
  end
end
