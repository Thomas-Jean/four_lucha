defmodule FourLucha.Character do
  @moduledoc false
  @item "character"
  @items "characters"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Character, as: Character
  require FourLucha.Client

  defp get_resource do
    Character
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
