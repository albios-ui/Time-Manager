defmodule App.MainContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :csrf_token, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :csrf_token, :type])
    |> validate_required([:username, :email, :password, :type])
    |> validate_format(:email, ~r/^[a-z0-9.-_]+[@]{1}[a-z0-9.-_]+[.]{1}[a-z]{2,10}$/)
    |> unique_constraint(:email)
  end
end
