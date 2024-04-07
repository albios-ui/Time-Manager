defmodule AppWeb.UserController do
  use AppWeb, :controller

  alias App.MainContext
  alias App.MainContext.User
  use Joken.Config

  require Logger

  action_fallback AppWeb.FallbackController

  # :create
  plug :check_auth when action in [:index, :show, :update, :update_from_logged_user, :delete, :logout, :get_login]

  def check_auth(conn, _params) do
    # [head | _] = get_req_header(conn, "jwt_tokekn")
    token = get_req_header(conn, "jwt_token")
    if length(token) != 0 do
      [head | _] = token
      decrypted_token = MainContext.decode_jwt_token(head)

      if (decrypted_token["exp"] > Joken.current_time()) do
        user = MainContext.get_user(decrypted_token["user_id"])
        if (is_nil(user)) do
          conn
          |> put_status(:unauthorized)
          |> render(AppWeb.UserView, "error.json", errors: "User describe in token wasn't found.")
          |> halt()
        else
          if (user.csrf_token == decrypted_token["csrf_token"]) do
            conn
            |> assign(:user_id, decrypted_token["user_id"])
            |> assign(:decrypted_token, decrypted_token)
            |> assign(:current_user, user)
          else
            conn
            |> put_status(:unauthorized)
            |> render(AppWeb.UserView, "error.json", errors: "csrf_token in token doesn't match.")
            |> halt()
          end
        end
      else
        conn
        |> put_flash(:error, "Your session has expired")
        |> put_status(:unauthorized)
        |> delete_session(:jwt_token)
        |> render(AppWeb.UserView, "error.json", errors: "Your token has expired")
        |> halt()
      end
    else
      conn
      |> put_status(:unauthorized)
      |> render(AppWeb.UserView, "error.json", errors: "Unauthorized")
      |> halt()
    end
  end


  def verify_user_id_and_return_user(conn, user_id) do
    case MainContext.get_user(user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(AppWeb.UserView, "error.json", errors: "User not found")
        |> halt()
      user ->
        user
    end
  end

  def setDefaultValueIfNil(value, defaultValue) do
    if is_nil(value) do
      defaultValue
    else
      value
    end
  end

  def index(conn, _params) do
    params = conn.query_params
    email = setDefaultValueIfNil(params["email"], "")
    username = setDefaultValueIfNil(params["username"], "")

    users = MainContext.list_users_with_email_and_username(email, username)
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # crypt password
    user_params = Map.put(user_params, "password", Base.encode64(user_params["password"]))

    # create user and return it
    with {:ok, %User{} = user} <- MainContext.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"userID" => id}) do
    user = MainContext.get_user(id)
    render(conn, "show.json", user: user)
  end

  def doUpdate(conn, user, user_params) do
    with {:ok, %User{} = user} <- MainContext.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"userID" => id, "user" => user_params}) do
    user = MainContext.get_user(id)
    if is_nil(user_params["password"]) do
      doUpdate(conn, user, user_params)
    else
      user_params = Map.put(user_params, "password", Base.encode64(user_params["password"]))
      doUpdate(conn, user, user_params)
    end
  end

  def delete(conn, %{"userID" => id}) do
    user = MainContext.get_user!(id)

    with {:ok, %User{}} <- MainContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"username" => username, "password" => password}) do
    with {:ok, %User{} = user} <- MainContext.get_user_by_username(username) do
      if user.password == Base.encode64(password) do
        csrf_token = get_csrf_token()
        with {:ok, %User{} = user} <- MainContext.update_user(user, %{csrf_token: csrf_token}) do
          jwt_token = MainContext.generate_jwt_token(user)
            conn
              |> render("login.json", user_id: user.id, user_type: user.type, jwt_token: jwt_token)
            # |> render("test.json", test: jwt_token)
        else
          _ -> conn |> render("error.json", errors: "Error while updating user")
        end
      else
        conn
          |>  put_status(:unauthorized)
          |>  render("error.json", errors: "Wrong password")
      end
    else
      {:error, "User not found"} ->
         render(conn, "error.json", errors: "User not found")
    end
  end

  def logout(conn, _params) do
    update(conn, %{"userID" => conn.assigns.current_user.id, "user" => %{csrf_token: nil}})
    conn
      |> render("logout.json", message: "csrf_token deleted successfully")
  end

  def get_login(conn, _params) do
    conn
      |> render("token.json", token: conn.assigns.decrypted_token)
  end

  def update_from_logged_user(conn, %{"user" => user_params}) do
    update(conn, %{"userID" => conn.assigns.user_id, "user" => user_params})
  end
end
