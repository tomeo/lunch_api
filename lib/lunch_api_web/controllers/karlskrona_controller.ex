alias LunchApiWeb.Scrapers.Aggregators.MatOchMat
alias LunchApi.MenuService

defmodule LunchApiWeb.KarlskronaController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    cache_key = "karlskrona_#{Date.utc_today()}"

    tasks = [
      Task.async(fn -> MatOchMat.city("karlskrona") end),
    ]

    menus = MenuService.get_menus(cache_key, tasks)

    json(conn, menus)
  end
end
