defmodule LunchApiWeb.SlackResponder do
  import Plug.Conn

  def slack_request?(conn) do
    get_req_header(conn, "x-slack-signature") != [] and
      get_req_header(conn, "x-slack-request-timestamp") != []
  end

  def format_response(menus) do
    menus
    |> Enum.map(fn menu ->
      dishes_text =
        menu.dishes
        |> Enum.map(fn dish ->
          price_text = if dish.price != "", do: " (#{dish.price} kr)", else: ""
          "- #{dish.dish}#{price_text}"
        end)
        |> Enum.join("\n")

      "*#{menu.name}:*\n#{dishes_text}"
    end)
    |> Enum.join("\n\n")
  end
end
