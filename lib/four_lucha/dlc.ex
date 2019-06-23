defmodule FourLucha.DLC do
  @moduledoc false
  @item "dlc"
  @items "dlcs"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.DLC, as: DLC
  require FourLucha.Client

  defp get_resource do
    DLC
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
