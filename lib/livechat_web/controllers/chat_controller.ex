defmodule LivechatWeb.ChatController do
  use LivechatWeb, :controller

  alias Livechat.Chat

  def index(conn, _params) do
    live_index(conn)
  end

  def create(conn, %{"message" => params}) do
    case Chat.create_message(params) do
      {:ok, message} ->
        conn
        |> redirect(to: Routes.chat_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> live_index
    end
  end

  defp live_index(conn) do
    Phoenix.LiveView.Controller.live_render(
      conn,
      LivechatWeb.Live.Index,
      session: %{}
    )
  end
end
