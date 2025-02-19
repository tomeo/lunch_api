alias LunchApiWeb.Scrapers.Aggregators.MatOchMat

defmodule LunchApiWeb.KarlskronaController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    tasks = [
      Task.async(fn -> MatOchMat.city("karlskrona") end),
    ]

    menus = fetch_menus_concurrently(tasks)

    json(conn, menus)
  end

  defp fetch_menus_concurrently(tasks) do
    Task.await_many(tasks)
    |> Enum.concat()
  end
end
