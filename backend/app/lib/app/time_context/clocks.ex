defmodule App.TimeContext.Clocks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do

    field :start, :naive_datetime
    field :status, :boolean, default: false
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(clocks, attrs) do
    clocks
    |> cast(attrs, [:start, :status, :user])
    |> validate_required([:start, :status])
  end
end
