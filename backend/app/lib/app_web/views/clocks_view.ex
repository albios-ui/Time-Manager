defmodule AppWeb.ClocksView do
  use AppWeb, :view
  alias AppWeb.ClocksView

  def render("index.json", %{clocks: clocks}) do
    %{data: render_many(clocks, ClocksView, "clocks.json")}
  end

  def render("show.json", %{clocks: clocks}) do
    %{data: render_one(clocks, ClocksView, "clocks.json")}
  end

  def render("clocks.json", %{clocks: clocks}) do
    %{
      id: clocks.id,
      start: clocks.start,
      status: clocks.status,
      user: clocks.user
    }
  end

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("info.json", %{info: info}) do
    %{
      info: info,
      data: []
    }
  end
end
