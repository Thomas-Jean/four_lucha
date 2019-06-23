defmodule FourLucha.Theme do
  @moduledoc false
  @item "theme"
  @items "themes"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Theme, as: Theme
  require FourLucha.Client

  defp get_resource do
    Theme
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
