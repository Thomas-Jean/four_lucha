defmodule FourLucha.Accessory do
  @moduledoc false
  @item "accessory"
  @items "accessories"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Accessory, as: Accessory
  require FourLucha.Client

  defp get_resource do
    Accessory
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
