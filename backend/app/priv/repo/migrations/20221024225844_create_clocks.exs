defmodule App.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :start, :naive_datetime
      add :status, :boolean, default: false, null: false
      add :user, references(:users, on_delete: :delete_all)

      timestamps()
    end
    create index(:clocks, [:user])
  end
end
