defmodule LunchApiWeb.SlackResponder do
  import Plug.Conn

  def slack_request?(conn) do
    get_req_header(conn, "x-slack-signature") != [] and
      get_req_header(conn, "x-slack-request-timestamp") != []
  end

  def format_response(menus) do
    menus
    |> List.flatten()  # Flatten the list if it contains nested lists
    |> Enum.map(fn menu ->
      name = Map.get(menu, :name, "Unknown")
      dishes = Map.get(menu, :dishes, [])

      dishes_text =
        dishes
        |> Enum.map(fn dish ->
          dish_name = Map.get(dish, :dish, "Unknown Dish")
          price = Map.get(dish, :price, "")
          price_text = if price != "", do: " (#{price} kr)", else: ""
          "- #{dish_name}#{price_text}"
        end)
        |> Enum.join("\n")

      "*#{name}:*\n#{dishes_text}"
    end)
    |> Enum.join("\n\n")
  end
end
