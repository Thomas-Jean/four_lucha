defmodule FourLucha.Genre do
  @moduledoc false
  @item "genre"
  @items "genres"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Genre, as: Genre
  require FourLucha.Client

  defp get_resource do
    Genre
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
