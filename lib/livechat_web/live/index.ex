defmodule LivechatWeb.Live.Index do
  use Phoenix.LiveView

  alias Livechat.Chat
  alias Livechat.Chat.Message

  alias LivechatWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    if connected?(socket), do: Chat.subscribe()

    message = if session["message_id"], do: Chat.get_message!(session["message_id"]), else: nil

    {:ok, fetch(socket, message)}
  end

  def render(assigns) do
    LivechatWeb.ChatView.render("index.html", assigns)
  end

  def handle_event("delete_message", %{"id" => id}, socket) do
    message = Chat.get_message!(id)

    case Chat.delete_message(message) do
      {:ok, _message} ->
        {:noreply, fetch(socket)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("edit_message", %{"id" => id}, socket) do
    message = Chat.get_message!(id)
    changeset = Chat.change_message(message)
    {:noreply, fetch(socket, message, changeset)}
  end

  def handle_event("cancel_edit", _params, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("validate", %{"message" => params}, socket) do
    changeset =
      %Message{}
      |> Chat.change_message(params)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("send_message", %{"message" => params, "_method" => "put"}, socket) do
    message = Chat.get_message!(params["id"])

    case Chat.update_message(message, params) do
      {:ok, _message} ->
        {:noreply, fetch(socket)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("send_message", %{"message" => params}, socket) do
    case Chat.create_message(params) do
      {:ok, _message} ->
        {:noreply, fetch(socket)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def fetch(socket, message \\ nil, changeset \\ nil) do
    assign(socket, %{
      messages: Chat.list_messages(),
      changeset: changeset || Chat.change_message(message || %Message{}),
      message: message,
      action: action(socket, message)
    })
  end

  def action(socket, message) do
    if message do
      Routes.chat_path(socket, :update, message)
    else
      Routes.chat_path(socket, :create)
    end
  end

  def handle_info({Chat, [:message, _event_type], _message}, socket) do
    {:noreply, fetch(socket)}
  end
end
