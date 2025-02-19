defmodule LunchApi.Cache do
  use Nebulex.Cache,
    otp_app: :lunch_api,
    adapter: Nebulex.Adapters.Local
end
