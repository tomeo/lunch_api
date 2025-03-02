defmodule LunchApi.Cache do
  use Nebulex.Cache,
    otp_app: :lunch_api,
    adapter: Nebulex.Adapters.Local

  def get_or_fetch(key, fetch_fun) do
    case get(key) do
      nil ->
        data = fetch_fun.()
        put(key, data)
        data
      cached_data ->
        cached_data
    end
  end
end
