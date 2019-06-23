defmodule FourLucha.Release do
  @moduledoc false
  @item "release"
  @items "releases"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Release, as: Release
  require FourLucha.Client

  defp get_resource do
    Release
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
