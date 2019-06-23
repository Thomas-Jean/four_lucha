defmodule FourLucha.Game do
  @moduledoc false
  @item "game"
  @items "games"
  use FourLucha.BaseHelpers
  use FourLucha.BaseSingular
  use FourLucha.BasePlural

  alias FourLucha.Resource.Game, as: Game
  require FourLucha.Client

  defp get_resource do
    Game
  end

  defp get_known_query_params do
    [:filter, :sort, :limit, :offset]
  end
end
