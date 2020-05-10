defmodule BlurbleWeb.SessionController do
  use BlurbleWeb, :controller

  alias Blurble.{UserManager, UserManager.User, UserManager.Guardian}

  import BlurbleWeb.Helpers.Errors

  def create(conn, _params) do
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/protected")
    else
      render(conn, "create.html", action: Routes.session_path(conn, :sign_up))
    end
  end

  def sign_up(conn, %{
        "user" => %{"username" => username, "email" => email, "password" => password}
      }) do
    UserManager.create_user(%{username: username, email: email, password: password})
    |> signup_reply(conn)
  end

  def new(conn, _params) do
    changeset = UserManager.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/protected")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserManager.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp signup_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Thanks for signing up!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/protected")
  end

  defp signup_reply({:error, changeset}, conn) do
    conn
    |> put_flash(:error, Enum.join(full_messages(changeset), ", "))
    |> create(%{})
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/protected")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
