defmodule FourLucha.Region do
  @moduledoc false
  @item "region"
  @items "regions"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Region, as: Region
  require FourLucha.Client

  defp get_resource do
    Region
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
