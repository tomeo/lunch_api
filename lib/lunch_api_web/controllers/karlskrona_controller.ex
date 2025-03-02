alias LunchApi.DataFetcher
alias LunchApi.Cache

defmodule LunchApiWeb.KarlskronaController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    cache_key = "karlskrona_#{Date.utc_today()}"
    data = Cache.get_or_fetch(cache_key, &DataFetcher.fetch_karlskrona_data/0)
    json(conn, data)
  end
end
