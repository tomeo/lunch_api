alias LunchApiWeb.Scrapers.Helsingborg.{Grytan, PhuunThaiHeden}
alias LunchApiWeb.Scrapers.Aggregators.MatOchMat

defmodule LunchApiWeb.HelsingborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    tasks = [
      Task.async(fn -> MatOchMat.city("helsingborg") end),
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    menus = fetch_menus_concurrently(tasks)

    json(conn, menus)
  end

  def ramlosa(conn, _params) do
    tasks = [
      Task.async(fn -> Grytan.menu() end),
      Task.async(fn -> PhuunThaiHeden.menu() end)
    ]

    menus = fetch_menus_concurrently(tasks)

    json(conn, menus)
  end

  def oceanhamnen(conn, _params) do
    restaurants = [
      "Brasseriet",
      "Backhaus Oceanhamnen"
    ]
    menu = MatOchMat.city("helsingborg")
    |> Enum.filter(fn restaurant -> Enum.member?(restaurants, restaurant.name) end)

    menus = fetch_menus_concurrently(menu)

    json(conn, menus)
  end

  defp fetch_menus_concurrently(tasks) do
    Enum.map(tasks, &Task.await/1)
    |> Enum.concat
  end
end
