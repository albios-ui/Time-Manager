defmodule AppWeb.UserView do
  use AppWeb, :view
  alias AppWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      type: user.type
    }
  end

  def render("login.json", %{user_id: user_id, user_type: user_type, jwt_token: jwt_token}) do
    %{
      user_type: user_type,
      user_id: user_id,
      jwt_token: jwt_token
    }
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("test.json", %{test: test}) do
    %{test: test}
  end

  def render("token.json", %{token: token}) do
    %{
      # aud: token["aud"],
      exp: token["exp"],
      # iat: token["iat"],
      # iss: token["iss"],
      # jti: token["jti"],
      csrf_token: token["csrf_token"],
      user_id: token["user_id"],
      user_type: token["user_type"],
      username: token["username"],
      email: token["email"],
      server_time: Joken.current_time()
    }
  end

  def render("logout.json", %{message: message}) do
    %{message: message}
  end
end
