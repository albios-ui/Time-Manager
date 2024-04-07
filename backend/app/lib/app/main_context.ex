defmodule App.MainContext do
  @moduledoc """
  The MainContext context.
  """

  import Ecto.Query, warn: false
  import JOSE.JWT, except: [from: 2]
  import Plug.CSRFProtection
  import Config
  use Joken.Config
  alias App.Repo

  alias App.MainContext.User

  require Logger

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_with_email_and_username(email, username) do
    Repo.all(
      from u in User,
      where: ilike(u.email, ^("%" <> email <> "%")),
      where: ilike(u.username, ^("%" <> username <> "%"))
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  Gets a single user by email and username.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_params!("chris@mail.fr","chris")
      %User{}

      iex> get_user!("aze@rty.fr","azer")
      ** (Ecto.NoResultsError)

  """
  def get_user_by_params(email, username), do: Repo.get_by(User, email: email, username: username)

  def get_user_by_username(username) do
    user = Repo.one(
      from c in User,
      where: c.username == ^username
    )
    if user == nil do
      {:error, "User not found"}
    else
      {:ok, user}
    end
  end
  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def token_configuration do
    token_config = %{}
    token_config = Map.put(token_config, "scope", %Joken.Claim{
      generate: fn -> Joken.current_time() + (24 * 60 * 60) end, #  + (30 * 24 * 60 * 60)
      validate: fn val, _claims, _context -> val < Joken.Config.current_time() end
    })
  end

  def create_token(jwt_info) do
    secret = System.get_env("PASSWORD")
    Logger.debug "Var value: #{inspect(secret)}"
    signer = Joken.Signer.create("HS256", "secretPasswordWichIsNotVisibleForApe")
    {:ok, claims} = Joken.generate_claims(token_config, jwt_info)
    {:ok, jwt, claims} = Joken.encode_and_sign(claims, signer)
    jwt
  end

  def generate_jwt_token(user) do
    jwt_info = %{
      user_id: user.id,
      user_type: user.type,
      username: user.username,
      email: user.email,
      csrf_token: user.csrf_token
    }
    token = create_token(jwt_info)
  end

  def decode_jwt_token(token) do
    signer = Joken.Signer.create("HS256", "secretPasswordWichIsNotVisibleForApe")
    {:ok, claims} = Joken.verify(token, signer)
    claims
  end
end
