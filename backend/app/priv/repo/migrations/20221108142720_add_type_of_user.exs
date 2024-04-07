defmodule App.Repo.Migrations.AddTypeOfUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :type, :string, default: "worker", null: false
    end
  end
end
