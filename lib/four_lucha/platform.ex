defmodule FourLucha.Platform do
  @moduledoc false
  @item "platform"
  @items "platforms"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Platform, as: Platform
  require FourLucha.Client

  defp get_resource do
    Platform
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
