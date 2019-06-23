defmodule FourLucha.Franchise do
  @moduledoc false
  @item "franchise"
  @items "franchises"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Franchise, as: Franchise
  require FourLucha.Client

  defp get_resource do
    Franchise
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
