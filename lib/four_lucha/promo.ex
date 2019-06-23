defmodule FourLucha.Promo do
  @moduledoc false
  @item "promo"
  @items "promos"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Promo, as: Promo
  require FourLucha.Client

  defp get_resource do
    Promo
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
