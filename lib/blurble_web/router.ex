defmodule BlurbleWeb.Router do
  use BlurbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {BlurbleWeb.LayoutView, :root}
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

    get "/signup", SessionController, :create
    post "/signup", SessionController, :sign_up
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
  end

  scope "/", BlurbleWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    live "/protected", Protected
  end
end
