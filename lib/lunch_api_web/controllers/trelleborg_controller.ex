alias LunchApi.DataFetcher
alias LunchApi.Cache

defmodule LunchApiWeb.TrelleborgController do
  use LunchApiWeb, :controller

  def index(conn, _params) do
    cache_key = "trelleborg_#{Date.utc_today()}"
    data = Cache.get_or_fetch(cache_key, &DataFetcher.fetch_trelleborg_data/0)
    json(conn, data)
  end
end
