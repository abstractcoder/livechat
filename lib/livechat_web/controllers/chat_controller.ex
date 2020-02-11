defmodule LivechatWeb.ChatController do
  use LivechatWeb, :controller

  alias Livechat.Chat

  def redirect_to_new(conn, _params) do
    redirect(conn, to: Routes.chat_path(conn, :new))
  end

  def new(conn, _params) do
    live_index(conn)
  end

  def create(conn, %{"message" => params}) do
    case Chat.create_message(params) do
      {:ok, _message} ->
        conn
        |> redirect(to: Routes.chat_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> live_index
    end
  end

  def edit(conn, %{"id" => id}) do
    live_index(conn, %{"message_id" => id})
  end

  def update(conn, %{"id" => id, "message" => params}) do
    message = Chat.get_message!(id)

    case Chat.update_message(message, params) do
      {:ok, _message} ->
        conn
        |> redirect(to: Routes.chat_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> live_index
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Chat.get_message!(id)

    {:ok, _message} = Chat.delete_message(message)

    conn
    |> redirect(to: Routes.chat_path(conn, :new))
  end

  defp live_index(conn, session \\ %{}) do
    Phoenix.LiveView.Controller.live_render(
      conn,
      LivechatWeb.Live.Index,
      session: session
    )
  end
end
