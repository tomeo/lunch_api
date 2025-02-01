alias LunchApiWeb.Scrapers.Aggregators.MatOchMat

defmodule LunchApiWeb.TrelleborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    tasks = [
      Task.async(fn -> MatOchMat.city("trelleborg") end),
    ]

    menus = fetch_menus_concurrently(tasks)

    json(conn, menus)
  end

  defp fetch_menus_concurrently(tasks) do
    Enum.map(tasks, &Task.await/1)
    |> Enum.concat
  end
end
