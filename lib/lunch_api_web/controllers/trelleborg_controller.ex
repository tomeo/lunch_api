alias LunchApiWeb.Scrapers.Aggregators.MatOchMat
alias LunchApi.MenuService

defmodule LunchApiWeb.TrelleborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    cache_key = "trelleborg_#{Date.utc_today()}"

    tasks = [
      Task.async(fn -> MatOchMat.city("trelleborg") end),
    ]

    menus = MenuService.get_menus(cache_key, tasks)

    json(conn, menus)
  end
end
