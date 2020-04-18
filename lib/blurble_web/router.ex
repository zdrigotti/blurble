defmodule BlurbleWeb.Router do
  use BlurbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Blurble.UserManager.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BlurbleWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", BlurbleWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/protected", PageController, :protected
  end
end
