defmodule App.TimeContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `App.TimeContext` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2022-10-23 22:51:00],
        start: ~N[2022-10-23 22:51:00]
      })
      |> App.TimeContext.create_working_time()

    working_time
  end

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        start: ~N[2022-10-23 22:58:00],
        status: true
      })
      |> App.TimeContext.create_clocks()

    clocks
  end
end
