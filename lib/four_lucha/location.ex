defmodule FourLucha.Location do
  @moduledoc false
  @item "location"
  @items "locations"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Location, as: Location
  require FourLucha.Client

  defp get_resource do
    Location
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
