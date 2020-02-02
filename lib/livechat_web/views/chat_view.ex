defmodule LivechatWeb.ChatView do
  use LivechatWeb, :view

  alias Livechat.Chat.Message

  def edited?(message) do
    message.inserted_at != message.updated_at
  end
end
