defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :password, :string, null: 
      add :csrf_token, :string

      timestamps()
    end
  end
end
