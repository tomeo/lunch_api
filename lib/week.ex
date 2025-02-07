defmodule Week do
  def day_index() do
    Date.utc_today()
    |> Date.day_of_week
  end
end
