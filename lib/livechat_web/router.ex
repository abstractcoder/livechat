defmodule LivechatWeb.Router do
  use LivechatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LivechatWeb do
    pipe_through :browser

    anchor = "#message-anchor"

    get "/", ChatController, :redirect_to_new

    # These routes exist so that the Route helpers includes scrolling anchor
    get "/messages/new#{anchor}", ChatController, :new
    get "/messages/:id/edit#{anchor}", ChatController, :edit

    resources "/messages", ChatController, only: [:new, :create, :edit, :update, :delete]
    post "/messages/:id", ChatController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", LivechatWeb do
  #   pipe_through :api
  # end
end
