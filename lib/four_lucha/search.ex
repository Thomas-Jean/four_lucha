defmodule FourLucha.Search do
  @moduledoc false
  @items "search"
  use FourLucha.BaseHelpers
  use FourLucha.BasePlural

  require FourLucha.Client

  defp get_resource do
    Map
  end

  defp get_known_query_params do
    [:query, :resources, :limit, :page]
  end
end
