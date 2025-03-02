defmodule LunchApi.CacheRefresher do
  use GenServer
  alias LunchApi.DataFetcher
  alias LunchApi.Cache

  @refresh_interval :timer.hours(24)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state) do
    IO.puts("🚀 Preloading cache on startup...")
    refresh_cache()  # Run an immediate refresh at startup
    schedule_initial_refresh()
    {:ok, state}
  end

  defp schedule_initial_refresh do
    now = DateTime.utc_now()
    target_time = %{now | hour: 0, minute: 1, second: 0, microsecond: {0, 0}}

    target_time =
      if DateTime.compare(now, target_time) != :lt do
        DateTime.add(target_time, @refresh_interval, :millisecond)
      else
        target_time
      end

    delay = DateTime.diff(target_time, now, :millisecond)
    Process.send_after(self(), :refresh_cache, delay)
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh_cache, @refresh_interval)
  end

  def handle_info(:refresh_cache, state) do
    Task.start(fn ->
      try do
        refresh_cache()
      rescue
        exception ->
          IO.puts("❌ Cache refresh failed: #{inspect(exception)}")
          IO.puts("⚠️ Next refresh is still scheduled to avoid stopping updates.")
      end
    end)

    schedule_refresh()
    {:noreply, state}
  end

  defp refresh_cache do
    Cache.put("helsingborg_#{Date.utc_today()}", DataFetcher.fetch_helsingborg_data())
    Cache.put("oceanhamnen_#{Date.utc_today()}", DataFetcher.fetch_oceanhamnen_data())
    Cache.put("ramlosa_#{Date.utc_today()}", DataFetcher.fetch_ramlosa_data())
    Cache.put("karlskrona_#{Date.utc_today()}", DataFetcher.fetch_karlskrona_data())
    Cache.put("trelleborg_#{Date.utc_today()}", DataFetcher.fetch_trelleborg_data())

    IO.puts("✅ Cache successfully updated!")
  end
end
