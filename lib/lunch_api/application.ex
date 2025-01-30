defmodule LunchApi.Application do
  use Application

  def start(_type, _args) do
    IO.puts("LunchApi is listening on http://localhost:4000/...")

    children = [
      {Plug.Cowboy, scheme: :http, plug: LunchApi, options: [port: 4000]}
    ]

    opts = [strategy: :one_for_one, name: LunchApi.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
